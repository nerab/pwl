require 'helper'

class TestStoreMetaData < Test::Pwl::TestCase
  # when comparing timestamps, allow not more than this difference in seconds
  TIMESTAMP_PRECISION = 0.001

  def test_created
    assert_equal(nil, store.last_accessed)
    assert_in_delta(DateTime.now, store.created, TIMESTAMP_PRECISION)
  end

  def test_last_accessed
    assert_equal(nil, store.last_accessed)
    store.put('foobar', 'barfoot')
    assert_equal(nil, store.last_accessed)
    store.get('foobar')
    assert_in_delta(DateTime.now, store.last_accessed, TIMESTAMP_PRECISION)
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
    assert_in_delta(DateTime.now, store.last_modified, TIMESTAMP_PRECISION)
  end
end
