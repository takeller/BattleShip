require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/ship'
require './lib/cell'
require './lib/board'
# require './lib/game_setup'
require './lib/player'
require 'pry'

class PlayerTest < Minitest::Test
  def setup
    @kyle = Player.new(true)
    @computer = Player.new
  end
  def test_it_exists
    assert_instance_of Player, @kyle
  end

  def test_it_has_readable_attributes
    expected = ["A1","A2","A3","A4",
                "B1","B2","B3","B4",
                "C1","C2","C3","C4",
                "D1","D2","D3","D4"]
    assert_equal expected, @kyle.board.cells.keys
    assert_instance_of Board, @kyle.board
    assert_equal true, @kyle.human
    assert_equal "Submarine", @kyle.ships[:submarine].name
  end

  def test_it_can_tell_if_player_is_human
    assert_equal true, @kyle.is_human?
    assert_equal false, @computer.is_human?
  end

  def test_it_can_tell_player_has_lost
    assert_equal false, @kyle.has_lost?

    2.times {@kyle.ships[:submarine].hit}
    3.times {@kyle.ships[:cruiser].hit}

    assert_equal true, @kyle.has_lost?
  end

  def test_it_can_generate_computer_ship_placements
    cruiser = @computer.ships[:cruiser]
    submarine = @computer.ships[:submarine]
    @computer.computer_ship_coordinates(cruiser)

    assert_equal 3, @computer.computer_ship_coordinates(cruiser).count
    assert_equal 2, @computer.computer_ship_coordinates(submarine).count
    assert_equal true, @computer.board.valid_placement?(cruiser,
                       @computer.computer_ship_coordinates(cruiser))
    assert_equal true, @computer.board.valid_placement?(submarine,
                       @computer.computer_ship_coordinates(submarine))
  end

  def test_computer_can_place_ships
    assert_nil @computer.board.cells["B2"].ship
    assert_nil @computer.board.cells["C2"].ship
    assert_nil @computer.board.cells["D2"].ship
    assert_nil @computer.board.cells["D3"].ship
    assert_nil @computer.board.cells["D4"].ship

    @computer.stubs(:computer_ship_coordinates).returns(["B2", "C2", "D2"]).then.returns(["D3", "D4"])
    @computer.computer_place_ships
    cruiser = @computer.ships[:cruiser]
    submarine = @computer.ships[:submarine]
    assert_equal cruiser, @computer.board.cells["B2"].ship
    assert_equal cruiser, @computer.board.cells["C2"].ship
    assert_equal cruiser, @computer.board.cells["D2"].ship
    assert_equal submarine, @computer.board.cells["D3"].ship
    assert_equal submarine, @computer.board.cells["D4"].ship

  end

  def test_it_gets_the_starting_prompt
    expected = "I have laid out my ships on the grid.
    You now need to lay out your two ships.
    The Cruiser is 3 units long and the Submarine is 2 units long."
    assert_equal expected, @kyle.starting_prompt
  end

  def test_player_get_coordinates_turns_input_to_an_array
    @kyle.stubs(:user_input).returns ("A1 A2 A3")

    assert_equal ["A1", "A2", "A3"], @kyle.player_get_coordinates
  end

  def test_check_valid_coordinates_only_passes_valid_coordinates
    @kyle.stubs(:user_input).returns("A1 A2 A7").then.returns(("A1 A2 A3"))
    cruiser = @kyle.ships[:cruiser]

    assert_equal ["A1", "A2", "A3"], @kyle.check_valid_coordinates(cruiser)

    @kyle.stubs(:user_input).returns("B4 V2 Z33").then.returns("B1 C1")
    submarine = @kyle.ships[:submarine]
    assert_equal ["B1", "C1"], @kyle.check_valid_coordinates(submarine)
  end

  def test_players_can_place_ships
    cruiser = @kyle.ships[:cruiser]
    submarine = @kyle.ships[:submarine]

    assert_nil @kyle.board.cells["A1"].ship
    assert_nil @kyle.board.cells["A2"].ship
    assert_nil @kyle.board.cells["A3"].ship
    assert_nil @kyle.board.cells["B1"].ship
    assert_nil @kyle.board.cells["C1"].ship

    @kyle.stubs(:user_input).returns("A1 A2 A3").then.returns("B1 C1")
    @kyle.player_place_ships

    assert_equal cruiser, @kyle.board.cells["A1"].ship
    assert_equal cruiser, @kyle.board.cells["A2"].ship
    assert_equal cruiser, @kyle.board.cells["A3"].ship
    assert_equal submarine, @kyle.board.cells["B1"].ship
    assert_equal submarine, @kyle.board.cells["C1"].ship
  end
end
