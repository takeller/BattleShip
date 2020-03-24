require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require 'pry'

class CellTest < Minitest::Test

  def setup
    @cell = Cell.new("A1")
    @cruiser = Ship.new("cruiser", 3)
  end

  def test_it_exists
    assert_instance_of Cell, @cell
  end

  def test_coordinate_attribute
    assert_equal "A1", @cell.coordinate
  end

  def test_ship_empty_cell
    assert_nil @cell.ship
  end

  def test_place_ship
    assert_nil @cell.ship

    @cell.place_ship(@cruiser)

    assert_equal @cruiser, @cell.ship
  end

  def test_empty?
    assert_equal true, @cell.empty?

    @cell.place_ship(@cruiser)

    assert_equal false, @cell.empty?
  end
end
