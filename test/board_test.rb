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

  def test_it_has_cells_as_an_attribute
    assert_instance_of Hash, @board.cells
  end

  def test_make_grid
    grid = ["A1","A2","A3","A4","B1","B2","B3","B4","C1","C2","C3","C4","D1","D2","D3","D4"]
    assert_equal grid, @board.make_grid
  end

  def test_make_cells
    assert_equal 16, @board.cells.length
    @board.cells.each do |key, value|
      assert_instance_of Cell, value
    end
  end

  def test_valid_coordinate?
    assert_equal true, @board.valid_coordinate?("A1")
    assert_equal true, @board.valid_coordinate?("C4")
    assert_equal false, @board.valid_coordinate?("A5")
    assert_equal false, @board.valid_coordinate?("E1")
  end

  def test_consecutive_coordinates?

    assert_equal true, @board.consecutive_coordinates?(["A1","A2","A3"])
    assert_equal false, @board.consecutive_coordinates?(["A1","A3"])
    assert_equal false, @board.consecutive_coordinates?(["A1","A1"])
    assert_equal false, @board.consecutive_coordinates?(["A2","A1"])
    assert_equal true, @board.consecutive_coordinates?(["A1","B1"])
    assert_equal true, @board.consecutive_coordinates?(["A1","B1", "C1", "D1"])
    assert_equal true, @board.consecutive_coordinates?(["Z1","Z2", "Z3", "Z4"])
    assert_equal false, @board.consecutive_coordinates?(["B1","A1", "C1", "A1"])
  end

  def test_diagonal_coordinates?
    assert_equal false, @board.diagonal_coordinates?(["A1","A2","A3"])
    assert_equal false, @board.diagonal_coordinates?(["A1","B1","C1"])
    assert_equal true, @board.diagonal_coordinates?(["A1","B2","C3"])
  end

  def test_valid_placement_ship_length
    assert_equal true, @board.valid_placement?(@cruiser, ["A1", "A2", "A3"])
    assert_equal false, @board.valid_placement?(@cruiser, ["A1", "A2"])
    assert_equal false, @board.valid_placement?(@submarine, ["A1", "A2", "A3"])
  end

  def test_valid_placement_consecutive_coordinates

    assert_equal false, @board.valid_placement?(@cruiser, ["A1", "A2", "A4"])
    assert_equal false, @board.valid_placement?(@submarine, ["A1", "C1"])
    assert_equal false, @board.valid_placement?(@submarine, ["A2", "C1"])
    assert_equal false, @board.valid_placement?(@cruiser, ["A3", "A2", "A1"])
    assert_equal false, @board.valid_placement?(@submarine, ["C1", "B1"])
    assert_equal true, @board.valid_placement?(@submarine, ["B1", "C1"])
  end

  def test_valid_placement_diagonal_coordinates

    assert_equal false, @board.valid_placement?(@cruiser, ["A1", "B2", "C3"])
    assert_equal false, @board.valid_placement?(@submarine, ["C2", "D3"])
    assert_equal false, @board.valid_placement?(@cruiser, ["A3", "A4", "A5"])
    assert_equal false, @board.valid_placement?(@cruiser, ["C2", "D2", "D3"])
    assert_equal false, @board.valid_placement?(@cruiser, ["A1", "A2", "B2"])
  end

  def test_it_can_tell_if_ships_overlap
    cruiser = Ship.new("Cruiser", 3)

    assert_equal false, @board.ships_overlapping?(["A1", "B1", "C1"])
    assert_equal true, @board.valid_placement?(cruiser, ["A1", "B1", "C1"])
    @board.cells["A1"].place_ship(cruiser)

    assert_equal true, @board.ships_overlapping?(["A1", "B1", "C1"])
  end

  def test_it_can_place_ships
    assert_equal true, @board.cells["A1"].empty?

    cruiser = Ship.new("Cruiser", 3)

    @board.place(cruiser, ["A1", "B1", "C1"])
    assert_equal cruiser, @board.cells["A1"].ship
    assert_equal cruiser, @board.cells["B1"].ship
    assert_equal cruiser, @board.cells["C1"].ship
  end

  def test_it_will_not_place_ships_in_invalid_placement
    assert_equal true, @board.cells["A1"].empty?

    cruiser = Ship.new("Cruiser", 3)

    assert_equal "Invalid Placement", @board.place(cruiser, ["A1", "A2", "C1"])
  end

  def test_render_dont_show_ships
    expected = (
    "  1 2 3 4 \n" +
    "A . . . . \n" +
    "B . . . . \n" +
    "C . . . . \n" +
    "D . . . . \n"
    )
    assert_equal expected, @board.render
    @board.place(@cruiser, ["A1", "A2", "A3"])
    assert_equal expected, @board.render
  end

  def test_render_show_ships
    expected = (
    "  1 2 3 4 \n" +
    "A S S S . \n" +
    "B . . . . \n" +
    "C . . . . \n" +
    "D . . . . \n"
    )
    @board.place(@cruiser, ["A1", "A2", "A3"])
    assert_equal expected, @board.render(true)
  end

  def test_it_can_tell_all_letters_are_the_same
    assert_equal true, @board.letters_same?(["A1", "A2", "A3"])
    assert_equal true, @board.letters_same?(["B1", "B2", "B3"])
    assert_equal true, @board.letters_same?(["Z1", "Z2", "Z3"])
    assert_equal false, @board.letters_same?(["A1", "B1", "C1"])
  end

  def test_it_can_tell_all_numbers_are_the_same
    assert_equal true, @board.numbers_same?(["A1", "B1", "C1"])
    assert_equal true, @board.numbers_same?(["A2", "B2", "C2"])
    assert_equal true, @board.numbers_same?(["X33", "Y33", "Z33"])
    assert_equal false, @board.numbers_same?(["X34", "Y33", "Z33"])
    assert_equal false, @board.numbers_same?(["A1", "A2", "A3"])
  end

  def test_it_can_tell_coordinates_are_in_the_same_plane
    assert_equal true, @board.same_plane?(["A1", "B1", "C1"])
    assert_equal true, @board.same_plane?(["X3", "Y3", "Z3"])
    assert_equal true, @board.same_plane?(["Z1", "Z2", "Z3"])
    assert_equal true, @board.same_plane?(["A1", "A2", "A3"])
    assert_equal false, @board.same_plane?(["A1", "A2", "B2"])
    assert_equal false, @board.same_plane?(["A1", "B1", "B2"])
  end

end
