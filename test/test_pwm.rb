require 'helper'
require 'tempfile'

class TestPwm < Test::Unit::TestCase
  def setup
    @store_file = Tempfile.new(self.class.name)
    Pwm::Store.init(@store_file.path, 's3cret') 
  end

  def teardown
    @store_file.close
    @store_file.unlink
  end
  
  def test_open_save
    store = Pwm::Store.new(@store_file.path, 's3cret')
    assert store.get('foo').nil?
    store.put('foo', 'bar')
    assert_equal('bar', store.get('foo'))
  end
  
  # Read back raw PStore and ensure what we get is not clear text
  def test_encryption
    store = Pwm::Store.new(@store_file.path, 's3cret')
    assert store.get('foo').nil?
    store.put('foo', 'bar')
    raw = PStore.new(@store_file)
    assert_not_equal('bar', raw.transaction{raw['foo']})
    assert_not_nil(raw.transaction{raw['foo']})
  end
  
  def test_wrong_password
    file = Tempfile.new('foo')
    begin
      store = Pwm::Store.new(file, 's3cret')
      store.put('foo', 'bar')
      assert_equal('bar', store.get('foo'))
      store = Pwm::Store.new(file, 'secr3t')
      assert_nil(store.get('foo'))
    ensure
      file.close
      file.unlink
    end
  end
end
