require 'helper'

class TestBasics < Test::Pwm::AppTestCase
  def test_help
    assert_successful('Rabenau', 'help')
  end

  def test_no_args
    assert_error('invalid', '')
  end

  def test_unknown_command
    assert_error('invalid', 'foobar')
  end

  #
  # Tests that init creates a valid store
  #
  def test_init
    # TODO
  end

  #
  # Tests that initing with two passwords that don't match fails
  #
  def test_init_unmatching_passwords
    # TODO
  end

  #
  # Tests that force-initing an existing store results in a valid store
  #
  def test_init
    # TODO
  end

  #
  # Tests that cancelling a re-init does not change the store file
  #
  def test_init_cancel
    # TODO
  end
end
