require 'helper'
require 'tempfile'

class TestLockerConstruction < Test::Pwl::TestCase
  def test_existing_locker
    assert_raise Pwl::Locker::FileAlreadyExistsError do
      Pwl::Locker.new(locker_file, locker_password)
    end
  end

  def test_nonexisting_locker
    assert_raise Pwl::Locker::FileNotFoundError do
      Pwl::Locker.open(temp_file_name, locker_password)
    end
  end

  # fake level  (increasingly close to structure)
  USER    = 1 # user root exists
  SYSTEM  = 2 # user and system root exists
  CREATED = 3 # user and system root exists, system root contains created stamp
  SALT    = 4 # like above, plus salt is set to random value

  def test_existing_uninitialized_locker
    {USER    => Pwl::Locker::NotInitializedError,
     SYSTEM  => Pwl::Locker::NotInitializedError,
     CREATED => Pwl::Locker::NotInitializedError,
     SALT    => Pwl::Locker::WrongMasterPasswordError,
    }.each{|fake_level, error| assert assert_uninitialized(fake_level, error)}
  end

  private

  def assert_uninitialized(fake_level, error)
    existing_file = Tempfile.new(self.class.name)

    begin
      fake_locker(existing_file, fake_level)

      assert_raise(error) do
        Pwl::Locker.open(existing_file, locker_password)
      end
    ensure
       existing_file.close
       existing_file.unlink
    end
  end

  # Pretend that we have a locker with correct layout
  def fake_locker(existing_file, fake_level)
    locker = PStore.new(existing_file)
    locker.transaction{
      locker.commit if fake_level < USER
      locker[:user] = {}
      locker.commit if fake_level < SYSTEM
      locker[:system] = {}
      locker.commit if fake_level < CREATED
      locker[:system][:created] = DateTime.now
      locker.commit if fake_level < SALT
      locker[:system][:salt] = Random.rand.to_s
    }
  end
end
