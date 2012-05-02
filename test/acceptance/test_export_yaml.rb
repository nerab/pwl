require 'helper'
require 'yaml'

# Tests `pwl export --format yaml`
class TestExportYAML < Test::Pwl::AppTestCase
  def test_empty
    fixture = fixture("test_empty.yaml")
    assert_successful_yaml(fixture, 'export --format yaml')
  end

  def test_all
    test_vector = Hash['foo', 'one', 'bar', 'two', 'Chuck Norris', 'Roundhouse Kick']
    test_vector.each{|k,v|
      assert_successful('', "add '#{k}' '#{v}'")
    }
    
    now = DateTime.now.strftime('%F %R')
    fixture = fixture("test_all.yaml")
    
    assert_successful_yaml(fixture, 'export --format yaml')
  end

  def assert_successful_yaml(expected_out, cmd, password = locker_password)
    out, err, rc = execute(cmd, password)
    assert_equal(0, rc.exitstatus, "Expected exit status 0, but it was #{rc.exitstatus}. STDERR was: #{err}")
    assert(err.empty?, "Expected empty STDERR, but it yielded #{err}")

    actual   = YAML.load(out)
    expected = YAML.load(expected_out)
    
    # fix up actuals to match expectations
    actual[:created] = "2012-03-28T21:54:21+02:00"
    actual[:last_accessed] = "2012-03-28T22:01:49+02:00"
    actual[:last_modified] = "2012-03-29T22:46:29+02:00"

    # This is essentially the same as
    #   assert_equal(expected, actual)
    # but it provides better diagnostic output on error
    yaml_diff(expected, actual)
  end
  
  private
  def yaml_diff(expected, actual, context = nil)
    #assert_equal(expected.class, actual.class)
    
    case expected
    when Hash
      actual.keys.each do |key|
        yaml_diff(expected[key], actual[key], "#{context}/#{String == expected[key].class ? '@' : ''}#{key}")
      end
    when Array
      actual.each_with_index do |e, i|
        yaml_diff(expected[i], actual[i], "#{context}[#{i}]")
      end
    else
      assert_equal(expected, actual, "#{context} is not the same:")
    end
  end
end
