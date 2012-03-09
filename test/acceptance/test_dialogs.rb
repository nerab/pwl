require 'helper'

#
# Unit tests for dialogs
#
# Note that these teste are being excluded when the plain +rake+ file is run because these tests require manual
# intervention.
#
# Run these tests separately with
#
#   rake TEST=test/acceptance/test_dialogs.rb
#
class TestPasswordDialog < Test::Unit::TestCase
  CANDIDATES = %w[Homer Marge Bart Lisa Maggie Martin Ralph]

  def test_get_with_spaces
    expected = "#{CANDIDATES[Random.rand(CANDIDATES.size)]} #{CANDIDATES[Random.rand(CANDIDATES.size)]}"
    get_text(expected, Pwm::Dialog::Password)
  end

  def test_get_empty
    assert_equal('', Pwm::Dialog::Password.new(self.class.name, "Please just press Enter without entering any text.").get_input)
  end

  def test_get_without_spaces
    expected = CANDIDATES[Random.rand(CANDIDATES.size)]
    get_text(expected, Pwm::Dialog::Password)
  end

  def test_cancel
    assert_raise Pwm::Dialog::Cancelled do
      Pwm::Dialog::Password.new(self.class.name, "Please press the Escape key.").get_input
    end

    assert_raise Pwm::Dialog::Cancelled do
      Pwm::Dialog::Password.new(self.class.name, "Please press the Cancel button.").get_input
    end
  end

  private

  def get_text(expected, dlg_class)
    assert_equal(expected, dlg_class.new(self.class.name, "Please enter the string '#{expected}' (without the quotes) and press Enter.").get_input)
  end
end
