require 'helper'

class TestStoreSecurity < Test::Pwm::TestCase
  # Read back raw PStore and ensure what we get is not clear text, even though we know the structure of the store
  def test_encryption
    store.put('foo', 'bar')
    raw = PStore.new(store_file)
    assert_not_equal('bar', raw.transaction{raw[:user]['foo']})
    assert_not_nil(raw.transaction{raw[:user]['foo']})
  end

  def test_wrong_password
    assert_raise Pwm::Store::WrongMasterPasswordError do
      Pwm::Store.open(store_file, store_password.reverse)
    end
  end
end