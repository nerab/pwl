require 'helper'

# Tests `pwm passwd`
class TestPasswd < Test::Pwm::AppTestCase
  def test_blank_password
    assert_error('may not be blank', 'passwd')
  end

  def test_standard
    # If we are in a pipe (and we are in these tests), the new password is expected as first arg
    assert_successful('^$', 'passwd secr3t')
    
    # the old password must not work anymore
    # re-open with the changed password
  end
end
