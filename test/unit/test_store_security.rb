require 'helper'

class TestStoreSecurity < Test::Pwl::TestCase

  # Read back raw PStore and ensure what we get is not clear text, even though we know the structure of the store
  def test_encryption
    assert(!store.nil?, "Store expected, but it is nil")
    store.put('foo', 'bar')
    raw = PStore.new(store_file)
    assert_not_equal('bar', raw.transaction{raw[:user]['foo']})
    assert_nil(raw.transaction{raw[:user]['foo']}) # must not find cleartext entry
  end

  def test_wrong_password
    assert_raise Pwl::Store::WrongMasterPasswordError do
      Pwl::Store.open(store_file, store_password.reverse)
    end
  end

  def test_change_password
    assert(!store.nil?, "Store expected, but it is nil")
    store.put('Homer', 'Simpson')
    store.change_password!(store_password.reverse)

    # the old password must not work anymore
    assert_raise Pwl::Store::WrongMasterPasswordError do
      Pwl::Store.open(store_file, store_password)
    end

    # Read back with the changed password
    reopened = Pwl::Store.open(store_file, store_password.reverse)
    assert_equal('Simpson', reopened.get('Homer'))
  end
end
