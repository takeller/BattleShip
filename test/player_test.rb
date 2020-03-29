require 'minitest/autorun'
require 'minitest/pride'
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
    assert_equal true, @kyle.human
    assert_equal "Submarine", @kyle.ships[:submarine].name
  end

  def test_it_can_tell_if_player_is_human
    assert_equal true, @kyle.is_human?
    assert_equal false, @computer.is_human?
  end

  def test_it_can_tell_if_all_ships_have_sunk
    assert_equal false, @kyle.has_lost?

    2.times {@kyle.ships[:submarine].hit}
    3.times {@kyle.ships[:cruiser].hit}

    assert_equal true, @kyle.has_lost?
  end

  def test_it_can_generate_computer_ship_placements
    @computer.computer_ship_coordinates(@computer.ships[:cruiser])
    p @computer.ships[:cruiser]

    assert_equal 3, @computer.ships[:cruiser].length
    assert_equal true, @computer.board.valid_placement?(@computer.ships[:cruiser],
                       @computer.computer_ship_coordinates(@computer.ships[:cruiser]))
  end

end
