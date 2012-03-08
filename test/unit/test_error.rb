require 'helper'

class TestError < Test::Unit::TestCase
  def setup
    @message = Pwm::ErrorMessage.new("<%= first %> <%= last %>", 1)
  end

  def test_code_0
    assert_raise Pwm::ReservedMessageCodeError do
      Pwm::ErrorMessage.new('', 0)
    end
  end

  def test_to_s
    assert_equal('Error: Mislav Marohnic', @message.to_s(:first => "Mislav", "last" => "Marohnic"))
  end

  def test_to_s_empty
    assert_raise NameError do
      @message.to_s
    end
  end

  def test_code
    assert_equal(1, @message.exit_code)
  end

  def test_to_s_extra
    assert_equal('Error: Apu Nahasapeemapetilon', @message.to_s({:first => 'Apu', 'last' => 'Nahasapeemapetilon', :worklocation => 'Kwik-E-Mart'}))
  end
end
