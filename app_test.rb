ENV['RACK_ENV'] = 'test'

require 'test/unit'
require 'rack/test'
require 'json'
require_relative 'app'

class RangeHeaderTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  # Let's assert all of the valid Range examples pass from the HackerRack assignment!

  # Range: id ..
  def test_unbounded_range
    header 'Range', 'id ..'

    get '/'
    json_response = JSON.parse(last_response.body)

    assert last_response.ok?
    assert_equal Array, json_response.class
    assert_equal 200, json_response.count
    assert_equal 1, json_response.first['id']
    assert_equal 200, json_response.last['id']
  end

  # Range: id 1..
  def test_inclusive_unbounded_range_starting_at_id_1
    header 'Range', 'id 1..'

    get '/'
    json_response = JSON.parse(last_response.body)

    assert last_response.ok?
    assert_equal Array, json_response.class
    assert_equal 200, json_response.count
    assert_equal 1, json_response.first['id']
    assert_equal 200, json_response.last['id']
  end

  # Range: id 1..5
  def test_inclusive_bounded_range_id_1_through_5
    header 'Range', 'id 1..5'

    get '/'
    json_response = JSON.parse(last_response.body)

    assert last_response.ok?
    assert_equal Array, json_response.class
    assert_equal 5, json_response.count
    assert_equal 1, json_response.first['id']
    assert_equal 5, json_response.last['id']
  end

  # Range: id ]5..
  def test_exclusive_unbounded_range_id_5
    header 'Range', 'id ]5..'

    get '/'
    json_response = JSON.parse(last_response.body)

    assert last_response.ok?
    assert_equal Array, json_response.class
    assert_equal 196, json_response.count
    assert_equal 6, json_response.first['id']
    assert_equal 201, json_response.last['id']
  end

  # Range: id 1..; max=5
  def test_inclusive_unbounded_range_id_1_max_5
    header 'Range', 'id 1..; max=5'

    get '/'
    json_response = JSON.parse(last_response.body)

    assert last_response.ok?
    assert_equal Array, json_response.class
    assert_equal 5, json_response.count
    assert_equal 1, json_response.first['id']
    assert_equal 5, json_response.last['id']
  end

  # Range: id 1..; order=desc
  def test_inclusive_unbounded_range_id_1_order_desc
    header 'Range', 'id 1..; order=desc'

    get '/'
    json_response = JSON.parse(last_response.body)

    assert last_response.ok?
    assert_equal Array, json_response.class
    assert_equal 200, json_response.count
    assert_equal 201, json_response.first['id']
    assert_equal 2, json_response.last['id']
  end

  # Range: id ]5..10; max=5, order=desc
  def test_exclusive_bounded_range_id_5_to_10_order_desc
    header 'Range', 'id ]5..10; order=desc'

    get '/'
    json_response = JSON.parse(last_response.body)

    assert last_response.ok?
    assert_equal Array, json_response.class
    assert_equal 5, json_response.count
    assert_equal 10, json_response.first['id']
    assert_equal 6, json_response.last['id']
  end

  # I wanted to include this to show how my name ranges work.
  # It's silly, but it's technically a range :) (not sorted by id)
  def test_inclusive_bounded_range_name_1_to_4_max_4
    header 'Range', 'name my-app-1..my-app-4; max=4'

    get '/'
    json_response = JSON.parse(last_response.body)

    assert last_response.ok?
    assert_equal Array, json_response.class
    assert_equal 4, json_response.count
    assert_equal 1, json_response.first['id']
    assert_equal 101, json_response.last['id']
  end
end
