require 'helper'

# Tests `pwl delete`
class TestDelete < Test::Pwl::AppTestCase
  def test_delete_blank_key
    assert_error('may not be blank', 'delete')
  end

  def test_delete_simple
    assert_successful('', 'put foo bar')
    assert_successful('', 'delete foo')
    assert_error('No entry was found for foo', 'get foo')
  end
end
