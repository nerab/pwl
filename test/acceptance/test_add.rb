require 'helper'

# Tests `pwl add`
class TestAdd < Test::Pwl::AppTestCase
  def test_add_blank_key
    assert_error('may not be blank', 'add')
  end

  def test_add_simple
    assert_successful('', 'add foo bar')
    assert_successful('^bar$', 'get foo')
  end

  def test_add_update
    assert_successful('', 'add foo bar')
    assert_successful('', 'add foo baz') # just do it twice
    assert_successful('^baz$', 'get foo')
  end
end
