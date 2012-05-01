require 'helper'
require 'nokogiri/diff'

# Tests `pwl export`
class TestExport < Test::Pwl::AppTestCase
  def test_empty
    fixture = fixture("test_empty.html").gsub('CREATED_STAMP', DateTime.now.strftime('%F %R')).gsub('MODIFIED_STAMP', 'never').gsub('DATABASE_FILE', store_file)
    assert_successful_html(fixture, 'export')
  end

  def test_all
    test_vector = Hash['foo', 'one', 'bar', 'two', 'Chuck Norris', 'Roundhouse Kick']
    test_vector.each{|k,v|
      assert_successful('', "add '#{k}' '#{v}'")
    }
    
    now = DateTime.now.strftime('%F %R')
    fixture = fixture("test_all.html").gsub('CREATED_STAMP', now).gsub('MODIFIED_STAMP', now).gsub('DATABASE_FILE', store_file)
    
    assert_successful_html(fixture, 'export')
  end

  def assert_successful_html(expected_out, cmd, password = store_password)
    out, err, rc = execute(cmd, password)
    assert_equal(0, rc.exitstatus, "Expected exit status 0, but it was #{rc.exitstatus}. STDERR was: #{err}")
    assert(err.empty?, "Expected empty STDERR, but it yielded #{err}")

    actual   = Nokogiri::HTML(out)
    expected = Nokogiri::HTML(expected_out)

    differences = actual.diff(expected, :added => true, :removed => true)

    assert_equal(0, differences.count, "Unexpected differences in output. Diff:\n" << differences.collect{|change, node|
      case change
      when '+'
        "Actual: #{node.to_html}"
      when '-'
        "Expected: #{node.to_html}"
      end
    }.join("\n"))
  end
end
