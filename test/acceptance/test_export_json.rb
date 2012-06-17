require 'helper'
require 'json'

# Tests `pwl export --format json`
class TestExportJSON < Test::Pwl::AppTestCase
  def test_empty
    fixture = fixture("test_empty.json")
    assert_successful_json(fixture, 'export --format json')
  end

  def test_all
    test_vector = Hash['foo', 'one', 'bar', 'two', 'Chuck Norris', 'Roundhouse Kick']
    test_vector.each{|k,v|
      assert_successful('', "add '#{k}' '#{v}'")
    }

    now = DateTime.now.strftime('%F %R')
    fixture = fixture("test_all.json")

    assert_successful_json(fixture, 'export --format json')
  end

  def assert_successful_json(expected_out, cmd, password = locker_password)
    out, err, rc = execute(cmd, password)
    assert_equal(0, rc.exitstatus, "Expected exit status 0, but it was #{rc.exitstatus}. STDERR was: #{err}")
    assert(err.empty?, "Expected empty STDERR, but it yielded #{err}")

    actual   = JSON.parse(out)
    expected = JSON.parse(expected_out)

    # fix up actuals to match expectations
    actual["created"] = "2012-03-28T21:54:21+02:00"
    actual["last_accessed"] = "2012-03-28T22:01:49+02:00"
    actual["last_modified"] = "2012-03-29T22:46:29+02:00"
    actual['entries'].each do |entry|
      entry['uuid'] = 'mock-uuid'
    end

    # This is essentially the same as
    #   assert_equal(expected, actual)
    # but it provides better diagnostic output on error
    json_diff(expected, actual)
  end

  private
  def json_diff(expected, actual, context = nil)
    assert_equal(expected.class, actual.class, "JSON in context #{context} has unexpected class:")

    case expected
    when Hash
      actual.keys.each do |key|
        json_diff(expected[key], actual[key], "#{context}/#{String == expected[key].class ? '@' : ''}#{key}")
      end
    when Array
      actual.each_with_index do |e, i|
        json_diff(expected[i], actual[i], "#{context}[#{i}]")
      end
    else
      assert_equal(expected, actual, "#{context} is not the same:")
    end
  end
end
