require 'helper'

class TestLockerSecurity < Test::Pwl::TestCase

  # Read back raw PStore and ensure what we get is not clear text, even though we know the structure of the locker
  def test_encryption
    assert(!locker.nil?, "Locker expected, but it is nil")
    locker.add('foo', 'bar')
    raw = PStore.new(locker_file)
    assert_not_equal('bar', raw.transaction{raw[:user]['foo']})
    assert_nil(raw.transaction{raw[:user]['foo']}) # must not find cleartext entry
  end

  def test_wrong_password
    assert_raise Pwl::Locker::WrongMasterPasswordError do
      Pwl::Locker.open(locker_file, locker_password.reverse)
    end
  end

  def test_change_password
    assert(!locker.nil?, "Locker expected, but it is nil")
    locker.add('Homer', 'Simpson')
    locker.change_password!(locker_password.reverse)

    # the old password must not work anymore
    assert_raise Pwl::Locker::WrongMasterPasswordError do
      Pwl::Locker.open(locker_file, locker_password)
    end

    # Read back with the changed password
    reopened = Pwl::Locker.open(locker_file, locker_password.reverse)
    assert_equal('Simpson', reopened.get('Homer'))
  end
end
