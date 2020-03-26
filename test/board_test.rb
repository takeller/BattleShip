require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require 'pry'

class BoardTest < Minitest::Test
  def setup
    @board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end
  def test_it_exists
    assert_instance_of Board, @board
  end
  def test_cells
    assert_equal 16, @board.cells.length
    @board.cells.each do |key, value|
      assert_instance_of Cell, value
    end
  end

  def test_valid_coordinate?
    @board.cells
    assert_equal true, @board.valid_coordinate?("A1")
    assert_equal true, @board.valid_coordinate?("C4")
    assert_equal false, @board.valid_coordinate?("A5")
    assert_equal false, @board.valid_coordinate?("E1")
  end

  def test_consecutive_coordinates?
    @board.cells

    assert_equal true, @board.consecutive_coordinates?(["A1","A2","A3"])
    assert_equal false, @board.consecutive_coordinates?(["A1","A3"])
    assert_equal false, @board.consecutive_coordinates?(["A1","A1"])
    assert_equal false, @board.consecutive_coordinates?(["A2","A1"])
    assert_equal true, @board.consecutive_coordinates?(["A1","B1"])
    assert_equal true, @board.consecutive_coordinates?(["A1","B1", "C1", "D1"])
    assert_equal false, @board.consecutive_coordinates?(["B1","A1", "C1", "A1"])
  end
  def test_non_diagonal_coordinates?
    @board.cells
    assert_equal true, @board.non_diagonal_coordinates?(["A1","A2","A3"])
    assert_equal true, @board.non_diagonal_coordinates?(["A1","B1","C1"])
    assert_equal false, @board.non_diagonal_coordinates?(["A1","B2","C3"])
    assert_equal false, @board.non_diagonal_coordinates?(["A4","B2","C3"])
    assert_equal false, @board.non_diagonal_coordinates?(["A4","C1"])
  end

  def test_valid_placement_ship_length
    @board.cells
    assert_equal true, @board.valid_placement?(@cruiser, ["A1", "A2", "A3"])
    assert_equal false, @board.valid_placement?(@cruiser, ["A1", "A2"])
    assert_equal false, @board.valid_placement?(@submarine, ["A1", "A2", "A3"])
  end
  def test_valid_placement_consecutive_coordinates
    @board.cells

    assert_equal false, @board.valid_placement?(@cruiser, ["A1", "A2", "A4"])
    assert_equal false, @board.valid_placement?(@submarine, ["A1", "C1"])
    assert_equal false, @board.valid_placement?(@submarine, ["A2", "C1"])
    assert_equal false, @board.valid_placement?(@cruiser, ["A3", "A2", "A1"])
    assert_equal false, @board.valid_placement?(@submarine, ["C1", "B1"])
    assert_equal true, @board.valid_placement?(@submarine, ["B1", "C1"])
  end
  #
  def test_valid_placement_non_diagonal_coordinates
    @board.cells

    assert_equal false, @board.valid_placement?(@cruiser, ["A1", "B2", "C3"])
    assert_equal false, @board.valid_placement?(@submarine, ["C2", "D3"])
    assert_equal false, @board.valid_placement?(@cruiser, ["A3", "A4", "A5"])
  end

  def test_it_can_tell_if_ships_overlap
    cruiser = Ship.new("Cruiser", 3)
    @board.cells

    assert_equal false, @board.ships_overlapping?(["A1", "B1", "C1"])
    assert_equal true, @board.valid_placement?(cruiser, ["A1", "B1", "C1"])
    @board.board_cells["A1"].place_ship(cruiser)

    assert_equal true, @board.ships_overlapping?(["A1", "B1", "C1"])
  end

  def test_it_can_place_ships
    @board.cells
    assert_equal true, @board.board_cells["A1"].empty?

    cruiser = Ship.new("Cruiser", 3)

    @board.place(cruiser, ["A1", "B1", "C1"])
    assert_equal cruiser, @board.board_cells["A1"].ship
    assert_equal cruiser, @board.board_cells["B1"].ship
    assert_equal cruiser, @board.board_cells["C1"].ship
  end

  def test_it_will_not_place_ships_in_invalid_placement
    @board.cells
    assert_equal true, @board.board_cells["A1"].empty?

    cruiser = Ship.new("Cruiser", 3)

    assert_equal "Invalid Placement", @board.place(cruiser, ["A1", "A2", "C1"])
  end
end
