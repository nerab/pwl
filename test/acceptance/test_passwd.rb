require 'helper'

# Tests `pwm passwd`
class TestPasswd < Test::Pwm::AppTestCase
  def test_blank_password
    assert_error('May not be blank', 'passwd')
  end

  def test_standard
    assert_successful('', 'put foo bar')

    new_pwd = store_password.reverse

    # If we are in a pipe (and we are in these tests), the new password is expected as first arg
    assert_successful('^$', "passwd \"#{new_pwd}\"")

    # the old password must not work anymore
    assert_error('The master password is wrong', 'list')

    # re-open with the changed password
    assert_successful('^bar$', 'get foo', new_pwd)
  end
end
