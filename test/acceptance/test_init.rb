require 'helper'
require 'pty'
require 'expect'

class TestInit < Test::Pwm::AppTestCase
  #
  # Tests that initing with two passwords that don't match fails
  #
  # A session is expected to look like this (using s3cretPassw0rd at the first and secr3tPassw0rd at the second password prompt):
  #
  # $ bin/pwm init --force --verbose
  # Enter new master password:
  # ************** 
  # Enter master password again:
  # **************
  # Passwords do not match.
  # $
  # 
  def test_unmatching_passwords
    cmd = "bin/pwm init --force --verbose --file \"#{store_file}\""

    PTY.spawn(cmd){|pwm_out, pwm_in, pid|
      pwm_out.expect(/Enter new master password:/, 1){|r| 
        pwm_in.printf("s3cretPassw0rd\n")
      }

      pwm_out.expect(/Enter master password again:/, 1){|r| 
        pwm_in.printf("secr3tPassw0rd\n")
      }

      assert_response('Passwords do not match\.', pwm_out)
    }
  end

  #
  # Tests that initing an existing store without --force does not touch the existing store 
  #
  def test_exists
    assert_error('already exists', "init")
  end
  
  #
  # Tests that force-initing an existing store results in a valid store
  #
  def test_force
    # TODO
  end

  #
  # Tests that cancelling a forced re-init does not change the store file
  #
  def test_cancel
    # TODO
  end
  
  private
  
  def assert_response(expected, actual_io)  
    if !actual_io.expect(/#{expected}/, 1)
      raise StandardError.new("Expected response '#{expected}' was not matched")
    end
  end
end
