require 'helper'

class TestBasics < Test::Pwm::AppTestCase
  def test_help
    assert_successful('Rabenau', 'help')
  end

  def test_no_args
    assert_error('invalid', '')
  end

  def test_unknown_command
    assert_error('invalid', 'foobar')
  end
  
  def test_get_unknown_key
    
  end
  
  def test_get_known_key
    
  end
end
