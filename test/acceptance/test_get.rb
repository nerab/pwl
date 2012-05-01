require 'helper'

# Tests `pwl get`
class TestGet < Test::Pwl::AppTestCase
  def test_get_unknown_key
    assert_error('No entry was found for foo', 'get foo')
  end

  def test_get_blank_key
    assert_error('may not be blank', 'get')
  end

  def test_get_known_key
    assert_successful('', 'add foo bar') # TODO Use a fixture instead of add
    assert_successful('^bar$', 'get foo')
  end
end
