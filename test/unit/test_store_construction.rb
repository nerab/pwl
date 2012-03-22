require 'helper'
require 'tempfile'

class TestStoreConstruction < Test::Pwl::TestCase
  def test_existing_store
    assert_raise Pwl::Store::FileAlreadyExistsError do
      Pwl::Store.new(store_file, store_password)
    end
  end

  def test_nonexisting_store
    assert_raise Pwl::Store::FileNotFoundError do
      Pwl::Store.open(temp_file_name, store_password)
    end
  end

  # fake level  (increasingly close to structure)
  USER    = 1 # user root exists
  SYSTEM  = 2 # user and system root exists
  CREATED = 3 # user and system root exists, system root contains created stamp
  SALT    = 4 # like above, plus salt is set to random value

  def test_existing_uninitialized_store
    {USER    => Pwl::Store::NotInitializedError,
     SYSTEM  => Pwl::Store::NotInitializedError,
     CREATED => Pwl::Store::NotInitializedError,
     SALT    => Pwl::Store::WrongMasterPasswordError,
    }.each{|fake_level, error| assert assert_uninitialized(fake_level, error)}
  end

  private

  def assert_uninitialized(fake_level, error)
    existing_file = Tempfile.new(self.class.name)

    begin
      fake_store(existing_file, fake_level)

      assert_raise(error) do
        Pwl::Store.open(existing_file, store_password)
      end
    ensure
       existing_file.close
       existing_file.unlink
    end
  end

  # Pretend that we have a store with correct layout
  def fake_store(existing_file, fake_level)
    store = PStore.new(existing_file)
    store.transaction{
      store.commit if fake_level < USER
      store[:user] = {}
      store.commit if fake_level < SYSTEM
      store[:system] = {}
      store.commit if fake_level < CREATED
      store[:system][:created] = DateTime.now
      store.commit if fake_level < SALT
      store[:system][:salt] = Random.rand.to_s
    }
  end
end
