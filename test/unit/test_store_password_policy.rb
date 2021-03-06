require 'helper'

class TestLockerPasswordPolicy < Test::Pwl::TestCase
  def setup
    @locker_file = temp_file_name
  end

  def teardown
    File.unlink(@locker_file) if File.exist?(@locker_file)
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
    locker = ::Pwl::Locker.new(@locker_file, password)
    locker.add('foo', 'bar')
    assert_equal('bar', locker.get('foo').password)
  end

  def assert_invalid(password)
    assert_raise Pwl::InvalidMasterPasswordError do
      assert_valid(password)
    end
  end
end
