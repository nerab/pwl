require 'helper'

class TestLockerCRUD < Test::Pwl::TestCase
  def test_add_get
    locker.add('foo', 'bar')
    assert_equal('bar', locker.get('foo'))
  end

  def test_get_blank
    assert_raise Pwl::Locker::BlankKeyError do
      locker.get('')
    end

    assert_raise Pwl::Locker::BlankKeyError do
      locker.get(nil)
    end
  end

  def test_add_get_blank
    assert_raise Pwl::Locker::BlankValueError do
      locker.add('empty', '')
    end

    assert_raise Pwl::Locker::BlankValueError do
      locker.add('nil', nil)
    end
  end

  def test_unknown_key
    assert_raise Pwl::Locker::KeyNotFoundError do
      locker.get('foo')
    end
  end

  def test_list_empty
    assert_empty(locker.list)
  end

  def test_list
    test_vector = Hash['foo', 'one', 'bar', 'two', 'Chuck Norris', 'Roundhouse Kick']
    test_vector.each{|k,v| locker.add(k, v)}
    assert_equal(test_vector.keys, locker.list)
    locker.list.each{|key|
      assert_equal(test_vector[key], locker.get(key))
    }
  end

  def test_all
    test_vector = Hash['foo', 'one', 'bar', 'two', 'Chuck Norris', 'Roundhouse Kick']
    test_vector.each{|k,v| locker.add(k, v)}
    assert_equal(test_vector, locker.all)
    locker.all.each{|k,v|
      assert_equal(test_vector[k], v)
    }
  end

  def test_list_filter
    test_vector = Hash['foo', 'one', 'bar', 'two', 'Chuck Norris', 'Roundhouse Kick']
    test_vector.each{|k,v| locker.add(k, v)}

    filter = 'foo bar'
    expected = test_vector.keys.select{|k,v| k =~ /#{filter}/}
    assert_equal(expected, locker.list(filter))
  end
  
  def test_delete
    locker.add('foo', 'bar')
    assert_equal('bar', locker.delete('foo'))
    
    assert_raise Pwl::Locker::KeyNotFoundError do
      locker.get('foo')
    end
  end
  
  def test_delete_blank
    assert_raise Pwl::Locker::BlankKeyError do
      locker.delete('')
    end

    assert_raise Pwl::Locker::BlankKeyError do
      locker.delete(nil)
    end
  end

  def test_delete_unknown_key
    assert_raise Pwl::Locker::KeyNotFoundError do
      locker.delete('foo')
    end
  end
end
