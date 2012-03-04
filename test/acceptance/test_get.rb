require 'helper'

# Tests `pwm get`
class TestGet < Test::Pwm::AppTestCase
  def test_get_unknown_key
    assert_error('No entry was found for foo', 'get foo')
  end

  def test_get_known_key
    assert_successful('', 'put foo bar')
    assert_successful('^bar$', 'get foo')
  end
end
