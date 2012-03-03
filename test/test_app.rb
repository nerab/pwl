require 'helper'

class TestApp < Test::Unit::TestCase
  APP = 'bin/pwm'

  def test_no_args
    assert_error("")
  end

  def test_unknown_command
    assert_error("foobar")
  end
  
  private
  def assert_error(cmd)
    out, err, rc = Open3.capture3("#{APP} #{cmd}")
    assert_equal(1, rc.exitstatus)
    assert(out.empty?)
    assert(err =~ /invalid/)
  end
end
