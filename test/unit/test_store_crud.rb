require 'helper'

class TestStoreCRUD < Test::Pwm::TestCase
  def test_put_get
    store.put('foo', 'bar')
    assert_equal('bar', store.get('foo'))
  end

  def test_get_blank
    assert_raise Pwm::Store::BlankKeyError do
      store.get('')
    end

    assert_raise Pwm::Store::BlankKeyError do
      store.get(nil)
    end
  end

  def test_put_get_blank
    assert_raise Pwm::Store::BlankValueError do
      store.put('empty', '')
    end

    assert_raise Pwm::Store::BlankValueError do
      store.put('nil', nil)
    end
  end

  def test_unknown_key
    assert_raise Pwm::Store::KeyNotFoundError do
      store.get('foo')
    end
  end

  def test_list_empty
    assert_empty(store.list)
  end

  def test_list
    test_vector = Hash['foo', 'one', 'bar', 'two', 'Chuck Norris', 'Roundhouse Kick']
    test_vector.each{|k,v| store.put(k, v)}
    assert_equal(test_vector.keys, store.list)
    store.list.each{|key|
      assert_equal(test_vector[key], store.get(key))
    }
  end
end
