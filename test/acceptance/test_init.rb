require 'helper'
require 'pty'
require 'expect'

class TestInit < Test::Pwl::AppTestCase
  #
  # Tests that initing with two matching passwords succeeds
  #
  # A session is expected to look like this:
  #
  # $ bin/pwl init --force --verbose
  # Enter new master password:
  # **************
  # Enter master password again:
  # **************
  # Successfully initialized new locker at ...
  # $
  #
  def test_matching_passwords
    cmd = "bin/pwl init --force --verbose --file \"#{locker_file}\""

    PTY.spawn(cmd){|pwl_out, pwl_in, pid|
      assert_response('Enter new master password:', pwl_out)
      pwl_in.puts("secr3tPassw0rd")

      assert_response('Enter master password again:', pwl_out)
      pwl_in.puts("secr3tPassw0rd")

      assert_response('Successfully initialized new locker', pwl_out)
    }
  end

  #
  # Tests that initing with two passwords that don't match fails
  #
  # A session is expected to look like this (using s3cretPassw0rd at the first and secr3tPassw0rd at the second password prompt):
  #
  # $ bin/pwl init --force --verbose
  # Enter new master password:
  # **************
  # Enter master password again:
  # **************
  # Passwords do not match.
  # $
  #
  def test_unmatching_passwords
    cmd = "bin/pwl init --force --verbose --file \"#{locker_file}\""

    PTY.spawn(cmd){|pwl_out, pwl_in, pid|
      assert_response('Enter new master password:', pwl_out)
      pwl_in.puts("s3cretPassw0rd")

      assert_response('Enter master password again:', pwl_out)
      pwl_in.puts("secr3tPassw0rd")

      assert_response('Passwords do not match\.', pwl_out)
    }
  end

  #
  # Tests that initing with a directory argument fail.
  #
  # A session is expected to look like this:
  #
  # $ bin/pwl init --file /tmp
  # pwl: File expected, but /tmp is a directory. Specify a regular file for the locker.
  # $
  #
  def test_locker_existing_dir
    dir = File.dirname(locker_file)
    assert(File.directory?(dir))

    cmd = "bin/pwl init --file \"#{dir}\""

    PTY.spawn(cmd){|pwl_out, pwl_in, pid|
      assert_response("pwl: File expected, but #{dir} is a directory. Specify a regular file for the locker.", pwl_out)
    }
  end

  #
  # Tests that initing an existing locker without --force does not touch the existing locker
  #
  def test_exists
    assert_error('already exists', "init")
  end

  #
  # Tests that cancelling a forced re-init does not change the locker file
  #
  def test_cancel
    # TODO
  end

  private

  def assert_response(expected, actual_io, timeout = 5)
    if !actual_io.expect(/#{expected}/, timeout)
      raise StandardError.new("Expected response '#{expected}' was not found within timeout of #{timeout} seconds.")
    end
  end
end
