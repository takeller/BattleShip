require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require 'pry'

class ShipTest < Minitest::Test

  def setup
    @cruiser = Ship.new("Cruiser", 3)
  end

  def test_it_exists
    assert_instance_of Ship, @cruiser
  end

  def test_it_has_a_length
    assert_equal 3, @cruiser.length
  end

  def test_it_has_a_name
    assert_equal "Cruiser", @cruiser.name
  end

  def test_by_default_health_equals_length
    assert_equal 3, @cruiser.health
  end

  def test_it_is_not_sunk_by_default
    assert_equal false, @cruiser.sunk?
  end

  def test_hit
    assert_equal 3, @cruiser.health

    @cruiser.hit

    assert_equal 2, @cruiser.health

    @cruiser.hit

    assert_equal 1, @cruiser.health
  end

  def test_it_sinks_when_health_equals_zero
    assert_equal 3, @cruiser.health
    3.times do
      @cruiser.hit
    end
    assert_equal true, @cruiser.sunk?
  end
end
