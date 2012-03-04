require 'helper'

class TestApp < Test::Pwm::TestCase
  APP = 'bin/pwm'

  def test_help
    assert_successful('Rabenau', 'help')
  end

  def test_no_args
    assert_error('invalid', '')
  end

  def test_unknown_command
    assert_error('invalid', 'foobar')
  end
  
  def test_get_unknown_key
    
  end
  
  def test_get_known_key
    
  end
  
  private
  def assert_successful(expected_out, cmd)
    out, err, rc = execute(cmd)
    assert_equal(0, rc.exitstatus)
    assert(err.empty?)
    assert(out =~ /#{expected_out}/)
  end
  
  def assert_error(expected_err, cmd)
    out, err, rc = execute(cmd)
    assert_equal(1, rc.exitstatus)
    assert(out.empty?)
    assert(err =~ /#{expected_err}/)
  end
  
  def execute(cmd)
    Open3.capture3("#{APP} #{cmd}")
  end
end
