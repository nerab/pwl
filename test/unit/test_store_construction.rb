require 'helper'

class TestStoreConstruction < Test::Pwm::TestCase
  def test_existing_store
    assert_raise Pwm::Store::FileAlreadyExistsError do
      Pwm::Store.new(store_file, store_password)
    end
  end

  def test_nonexisting_store
    assert_raise Pwm::Store::FileNotFoundError do
      Pwm::Store.open(temp_file_name, 's3cret passw0rd')
    end
  end
end
