require 'helper'

class TestStoreSecurity < Test::Pwm::TestCase
  # Read back raw PStore and ensure what we get is not clear text, even though we know the structure of the store
  def test_encryption
    store.put('foo', 'bar')
    raw = PStore.new(store_file)
    assert_not_equal('bar', raw.transaction{raw[:user]['foo']})
    assert_nil(raw.transaction{raw[:user]['foo']}) # must not find cleartext entry
  end

  def test_wrong_password
    assert_raise Pwm::Store::WrongMasterPasswordError do
      Pwm::Store.open(store_file, store_password.reverse)
    end
  end

  def test_change_password
    store.put('Homer', 'Simpson')
    store.change_password!(store_password.reverse)

    # the old password must not work anymore
    assert_raise Pwm::Store::WrongMasterPasswordError do
      Pwm::Store.open(store_file, store_password)
    end

    # Read back with the changed password
    reopened = Pwm::Store.open(store_file, store_password.reverse)
    assert_equal('Simpson', reopened.get('Homer'))
  end
end
