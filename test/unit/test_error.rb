require 'helper'

class TestError < Test::Unit::TestCase
  def setup
    @message = Pwl::ErrorMessage.new("<%= first %> <%= last %>", 1, :first => 'FIRSTNAME', :last => 'LASTNAME')
  end

  def test_code_0
    assert_raise Pwl::ReservedMessageCodeError do
      Pwl::ErrorMessage.new('', 0)
    end
  end

  def test_to_s
    assert_equal('Mislav Marohnic', @message.to_s(:first => "Mislav", "last" => "Marohnic"))
  end

  def test_to_s_empty
    assert_equal('FIRSTNAME LASTNAME', @message.to_s)
  end

  def test_code
    assert_equal(1, @message.exit_code)
  end

  def test_to_s_extra
    assert_equal('Apu Nahasapeemapetilon', @message.to_s({:first => 'Apu', 'last' => 'Nahasapeemapetilon', :worklocation => 'Kwik-E-Mart'}))
  end
end
