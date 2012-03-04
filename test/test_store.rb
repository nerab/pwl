require 'helper'
require 'tempfile'

class TestStore < Test::Pwm::TestCase
  def test_open_save
    store = Pwm::Store.new(@store_file.path, 's3cret')
    assert_raise Pwm::Store::KeyNotFoundError do
      store.get('foo')
    end
    store.put('foo', 'bar')
    assert_equal('bar', store.get('foo'))
  end
  
  # Read back raw PStore and ensure what we get is not clear text, even though we know the structure of the store
  def test_encryption
    store = Pwm::Store.new(@store_file.path, 's3cret')    
    store.put('foo', 'bar')
    raw = PStore.new(@store_file)
    assert_not_equal('bar', raw.transaction{raw[:user]['foo']})
    assert_not_nil(raw.transaction{raw[:user]['foo']})
  end
  
  def test_wrong_password
    assert_raise Pwm::Store::WrongMasterPasswordError do
      Pwm::Store.new(@store_file.path, 'secr3t')
    end
  end
end
