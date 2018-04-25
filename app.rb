# frozen_string_literal: true
require 'sinatra'
require 'sinatra/activerecord'
require_relative 'app_model'

require 'pry'

set :database, { adapter: 'sqlite3', database: 'db/development.sqlite3' }

get '/' do
  # parse all parts of range header, set defaults
  field, starting, ending, max, order = *range_header_parts(request.env['HTTP_RANGE'])

  # build the where fragment taking into account which parts of the target span were requested
  where = where_fragment(field, starting, ending)

  # allow the endpoint response body to be the array of app models turned into JSON
  App.where(where, starting: starting, ending: ending)
     .order(field.intern => order)
     .limit(max)
     .to_json
end

# Range header definition
# Range: <field> [[<exclusivity operator>]<start identifier>]]..[<end identifier>][;
#   [max=<max number of results>], [order=[<asc|desc>]]
def range_header_parts(header_string)
  field_and_span, modifiers    = *header_string.split(';')
  field,          span         = *field_and_span.split(" ")
  max,            order        = parsed_modifiers(modifiers)
  starting_index, ending_index = span_indicies(field, span)
  [field, starting_index, ending_index, max, order]
end

def parsed_modifiers(modifiers_string)
  raw   = modifiers_string&.split(',')&.map(&:strip)
  order = raw&.include?('order=desc') ? :desc : :asc
  max   = raw&.select { |val| val =~ /max=\d+/ }&.first&.sub('max=', '')&.to_i || 200
  [max, order]
end

def span_indicies(field, span_string)
  exclusive        = span_string[0] == ']' ? span_string.delete!(']') : false
  starting, ending = span_string.split('..').map { |val| val == '' ? nil : val.to_i }
  starting += 1 if exclusive

  if field == 'id'
    [starting, ending]
  else
    ["my-app-#{ starting }", "my-app-#{ ending }"]
  end
end

def where_fragment(field, starting, ending)
  where = ''
  where += "#{ field } >= :starting" if starting
  where += " AND " if starting && ending
  where += "#{ field } <= :ending" if ending
  where
end

