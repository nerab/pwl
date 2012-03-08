require 'helper'

class TestMessageZero < Test::Unit::TestCase
  def setup
    @msg = Pwm::Message.new("Name: <%= first %> <%= last %>")
  end

  def test_to_s
    assert_equal('Name: Mislav Marohnic', @msg.to_s(:first => "Mislav", "last" => "Marohnic"))
  end

  def test_to_s_empty
    assert_raise NameError do
      @msg.to_s
    end
  end

  def test_code
    assert_equal(0, @msg.exit_code)
  end

  def test_to_s_extra
    assert_equal('Name: Apu Nahasapeemapetilon', @msg.to_s({:first => 'Apu', 'last' => 'Nahasapeemapetilon', :worklocation => 'Kwik-E-Mart'}))
  end
end

class TestMessageNonZero < Test::Unit::TestCase
  def setup
    @code = Random.rand(255)
    @msg = Pwm::Message.new("Name: <%= first %> <%= last %>", @code)
  end

  def test_code
    assert_equal(@code, @msg.exit_code)
  end
end
