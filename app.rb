# frozen_string_literal: true

# Range header definition
# Range: <field> [[<exclusivity operator>]<start identifier>]]..[<end identifier>][; [max=<max number of results>], [order=[<asc|desc>]]

require 'sinatra'

get '/' do
  # parse range header
  # retrieve data
  # return requested data as JSON
  'hello!'
end

