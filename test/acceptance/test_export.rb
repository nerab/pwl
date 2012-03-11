require 'helper'

# Tests `pwm export`
class TestExport < Test::Pwm::AppTestCase
  def test_empty
    fixture = fixture("test_empty.html").gsub('CREATED_STAMP', DateTime.now.strftime('%F %R')).gsub('MODIFIED_STAMP', 'never').gsub('DATABASE_FILE', store_file)
    assert_successful(fixture, 'export')
  end

  def test_all
    test_vector = Hash['foo', 'one', 'bar', 'two', 'Chuck Norris', 'Roundhouse Kick']
    test_vector.each{|k,v|
      assert_successful('', "put '#{k}' '#{v}'")
    }
    
    now = DateTime.now.strftime('%F %R')
    fixture = fixture("test_all.html").gsub('CREATED_STAMP', now).gsub('MODIFIED_STAMP', now).gsub('DATABASE_FILE', store_file)
    assert_successful(fixture, 'export')
  end
end
