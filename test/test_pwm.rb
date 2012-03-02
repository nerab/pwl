require 'helper'
require 'tempfile'

class TestPwm < Test::Unit::TestCase
  def setup
    @store_file = Tempfile.new(self.class.name)
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
end
