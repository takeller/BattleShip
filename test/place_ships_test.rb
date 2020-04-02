require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/player'
require './lib/place_ships'
require 'pry'

class PlaceShipsTest < Minitest::Test

  def setup
    @kyle = Player.new(true)
    @computer = Player.new
    @player_ship_placement = PlaceShips.new(@kyle)
    @computer_ship_placement = PlaceShips.new(@computer)
  end
  def test_it_can_generate_computer_ship_placements
    cruiser = @computer_ship_placement.player.ships[:cruiser]
    submarine = @computer_ship_placement.player.ships[:submarine]
    @computer_ship_placement.computer_ship_coordinates(cruiser)

    assert_equal 3, @computer_ship_placement.computer_ship_coordinates(cruiser).count
    assert_equal 2, @computer_ship_placement.computer_ship_coordinates(submarine).count
    assert_equal true, @computer_ship_placement.player.board.valid_placement?(cruiser,
                       @computer_ship_placement.computer_ship_coordinates(cruiser))
    assert_equal true, @computer_ship_placement.player.board.valid_placement?(submarine,
                       @computer_ship_placement.computer_ship_coordinates(submarine))
  end

  def test_computer_can_place_ships
    assert_nil @computer_ship_placement.player.board.cells["B2"].ship
    assert_nil @computer_ship_placement.player.board.cells["C2"].ship
    assert_nil @computer_ship_placement.player.board.cells["D2"].ship
    assert_nil @computer_ship_placement.player.board.cells["D3"].ship
    assert_nil @computer_ship_placement.player.board.cells["D4"].ship

    @computer_ship_placement.stubs(:computer_ship_coordinates).returns(["B2", "C2", "D2"]).then.returns(["D3", "D4"])
    @computer_ship_placement.computer_place_ships


    cruiser = @computer_ship_placement.player.ships[:cruiser]
    submarine = @computer_ship_placement.player.ships[:submarine]
    assert_equal cruiser, @computer_ship_placement.player.board.cells["B2"].ship
    assert_equal cruiser, @computer_ship_placement.player.board.cells["C2"].ship
    assert_equal cruiser, @computer_ship_placement.player.board.cells["D2"].ship
    assert_equal submarine, @computer_ship_placement.player.board.cells["D3"].ship
    assert_equal submarine, @computer_ship_placement.player.board.cells["D4"].ship
  end

  def test_it_gets_the_starting_prompt
    expected = "I have laid out my ships on the grid.
    You now need to lay out your two ships.
    The Cruiser is 3 units long and the Submarine is 2 units long."
    assert_equal expected, @player_ship_placement.starting_prompt
  end

  def test_player_get_coordinates_turns_input_to_an_array
    @player_ship_placement.stubs(:user_input).returns ("A1 A2 A3")

    assert_equal ["A1", "A2", "A3"], @player_ship_placement.player_get_coordinates
  end

  def test_check_valid_coordinates_only_passes_valid_coordinates
    @player_ship_placement.stubs(:user_input).returns("A1 A2 A7").then.returns(("A1 A2 A3"))
    cruiser = @player_ship_placement.player.ships[:cruiser]

    assert_equal ["A1", "A2", "A3"], @player_ship_placement.check_valid_coordinates(cruiser)


    @player_ship_placement.stubs(:user_input).returns("B4 V2 Z33").then.returns("B1 C1")
    submarine = @player_ship_placement.player.ships[:submarine]
    assert_equal ["B1", "C1"], @player_ship_placement.check_valid_coordinates(submarine)
  end

  def test_players_can_place_ships
    cruiser = @player_ship_placement.player.ships[:cruiser]
    submarine = @player_ship_placement.player.ships[:submarine]

    assert_nil @player_ship_placement.player.board.cells["A1"].ship
    assert_nil @player_ship_placement.player.board.cells["A2"].ship
    assert_nil @player_ship_placement.player.board.cells["A3"].ship
    assert_nil @player_ship_placement.player.board.cells["B1"].ship
    assert_nil @player_ship_placement.player.board.cells["C1"].ship

    @player_ship_placement.stubs(:user_input).returns("A1 A2 A3").then.returns("B1 C1")
    @player_ship_placement.player_place_ships

    assert_equal cruiser, @player_ship_placement.player.board.cells["A1"].ship
    assert_equal cruiser, @player_ship_placement.player.board.cells["A2"].ship
    assert_equal cruiser, @player_ship_placement.player.board.cells["A3"].ship
    assert_equal submarine, @player_ship_placement.player.board.cells["B1"].ship
    assert_equal submarine, @player_ship_placement.player.board.cells["C1"].ship
  end
end
