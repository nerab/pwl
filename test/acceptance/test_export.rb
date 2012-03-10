require 'helper'

# Tests `pwm export`
class TestExport < Test::Pwm::AppTestCase
  def test_empty
    fixture = fixture("test_empty.html").gsub('DATE_TIME_STAMP', 'never')
#    assert_successful(fixture, 'export')
  end

  def test_all
    test_vector = Hash['foo', 'one', 'bar', 'two', 'Chuck Norris', 'Roundhouse Kick']
    test_vector.each{|k,v|
      assert_successful('', "put '#{k}' '#{v}'")
    }
    
    fixture = fixture("test_all.html").gsub('DATE_TIME_STAMP', DateTime.now.strftime('%F')) 
    assert_successful(fixture, 'export')
  end
end
