require 'helper'

class TestLockerMetaData < Test::Pwl::TestCase
  # when comparing timestamps, allow not more than this difference in seconds
  TIMESTAMP_PRECISION = 0.001

  def test_created
    assert_equal(nil, locker.last_accessed)
    assert_in_delta(DateTime.now, locker.created, TIMESTAMP_PRECISION)
  end

  def test_last_accessed
    assert_equal(nil, locker.last_accessed)
    locker.add('foobar', 'barfoot')
    assert_equal(nil, locker.last_accessed)
    locker.get('foobar')
    assert_in_delta(DateTime.now, locker.last_accessed, TIMESTAMP_PRECISION)
  end

  def test_last_accessed_nonexisting
    assert_equal(nil, locker.last_accessed)
    assert_raise Pwl::Locker::KeyNotFoundError do
      locker.get('foobar')
    end

    # Make sure a failed read is not counted as last_accessed
    assert_equal(nil, locker.last_accessed)
  end

  def test_last_modified
    assert_equal(nil, locker.last_modified)
    locker.add('foobar', 'barfoot')
    assert_in_delta(DateTime.now, locker.last_modified, TIMESTAMP_PRECISION)
  end
end
