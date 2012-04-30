require 'helper'

class TestStoreMetaData < Test::Pwl::TestCase
  # when comparing timestamps, allow not more than this difference in seconds
  TIMESTAMP_PRECISION = 1

  def test_created
    assert_equal(nil, store.last_accessed)
    assert_in_delta(DateTime.now.to_time.to_i, store.created.to_time.to_i, TIMESTAMP_PRECISION)
  end

  def test_failing_on_travis
    assert 0 < DateTime.now.to_time.to_i
  end

  def test_last_accessed
    assert_equal(nil, store.last_accessed)
    store.put('foobar', 'barfoot')
    assert_equal(nil, store.last_accessed)
    store.get('foobar')
    assert_in_delta(DateTime.now.to_time.to_i, store.last_accessed.to_time.to_i, TIMESTAMP_PRECISION)
  end

  def test_last_accessed_nonexisting
    assert_equal(nil, store.last_accessed)
    assert_raise Pwl::Store::KeyNotFoundError do
      store.get('foobar')
    end

    # Make sure a failed read is not counted as last_accessed
    assert_equal(nil, store.last_accessed)
  end

  def test_last_modified
    assert_equal(nil, store.last_modified)
    store.put('foobar', 'barfoot')
    assert_in_delta(DateTime.now.to_time.to_i, store.last_modified.to_time.to_i, TIMESTAMP_PRECISION)
  end
end
