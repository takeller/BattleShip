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

  def test_not_fired_upon_by_default
    assert_equal false, @cell.fired_upon?
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

  def test_fire_upon
    assert_equal false, @cell.fired_upon?
    assert_equal 3, @cruiser.health

    @cell.place_ship(@cruiser)
    @cell.fire_upon

    assert_equal true, @cell.fired_upon?
    assert_equal 2, @cruiser.health
  end

  def test_render_not_fired_upon
    assert_equal false, @cell.fired_upon?
    assert_equal ".", @cell.render
  end

  def test_render_miss
    assert_equal false, @cell.fired_upon?

    @cell.fire_upon

    assert_equal "M", @cell.render
  end

  def test_render_hit
    assert_equal false, @cell.fired_upon?

    @cell.place_ship(@cruiser)
    @cell.fire_upon

    assert_equal "H", @cell.render
  end

  def test_render_sunk
    assert_equal false, @cell.fired_upon?

    @cell.place_ship(@cruiser)
    3.times do
      @cell.fire_upon
    end

    assert_equal "X", @cell.render
  end

  def test_render_show_ship_true
    assert_equal false, @cell.fired_upon?

    @cell.place_ship(@cruiser)

    assert_equal "S", @cell.render(true)
  end

end
