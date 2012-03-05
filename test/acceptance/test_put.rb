require 'helper'

# Tests `pwm put`
class TestPut < Test::Pwm::AppTestCase
  def test_put_blank_key
    assert_error('may not be blank', 'put')
  end

  def test_put_simple
    assert_successful('', 'put foo bar')
    assert_successful('^bar$', 'get foo')
  end

  def test_put_update
    assert_successful('', 'put foo bar')
    assert_successful('', 'put foo baz') # just do it twice
    assert_successful('^baz$', 'get foo')
  end
end
