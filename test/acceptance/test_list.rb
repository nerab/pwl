require 'helper'

# Tests `pwm list`
class TestList < Test::Pwm::AppTestCase
  def test_list_empty
    assert_empty(store.list)
    assert_successful('^$', 'list')
  end

  def test_list_all
    test_vector = Hash['foo', 'one', 'bar', 'two', 'Chuck Norris', 'Roundhouse Kick']
    test_vector.each{|k,v|
      assert_successful('', "put '#{k}' '#{v}'")
    }

    assert_successful(test_vector.keys.join('-'), 'list -s "-"')
  end

  def test_list_filter
    test_vector = Hash['foo', 'one', 'foot', 'two', 'Homer Simpson', 'Apu Nahasapeemapetilon']
    test_vector.each{|k,v|
      assert_successful('', "put '#{k}' '#{v}'")
    }

    filter = 'foo'
    assert_successful(test_vector.keys.select{|k,v| k =~ /#{filter}/}.join(','), "list #{filter} -s ,")
  end
end