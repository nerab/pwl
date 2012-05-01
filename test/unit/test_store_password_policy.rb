require 'helper'

class TestStorePasswordPolicy < Test::Pwl::TestCase
  def setup
    @store_file = temp_file_name
  end

  def teardown
    File.unlink(@store_file) if File.exist?(@store_file)
  end

  def test_validations_ok_0
    assert_valid('abcd3fgh')
  end

  def test_validations_ok_1
    assert_valid('123A5678')
  end

  def test_validations_too_short_0
    assert_invalid(nil)
  end

  def test_validations_too_short_1
    assert_invalid('')
  end

  def test_validations_too_short_2
    assert_invalid('a')
  end

  def test_validations_too_short_3
    assert_invalid('abcdefg')
  end

  def test_validations_too_simple_0
    assert_invalid('        ')
  end

  def test_validations_too_simple_1
    assert_invalid('12345678')
  end

  def test_validations_too_simple_2
    assert_invalid('abcdefgh')
  end

  private

  def assert_valid(password)
    store = ::Pwl::Store.new(@store_file, password)
    store.add('foo', 'bar')
    assert_equal('bar', store.get('foo'))
  end

  def assert_invalid(password)
    assert_raise Pwl::InvalidMasterPasswordError do
      assert_valid(password)
    end
  end
end
