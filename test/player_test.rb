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
    @kyle = Player.new("Kyle")
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
    assert_equal "Kyle", @kyle.name
    assert_equal "Submarine", @kyle.ships[:submarine].name
  end

  def test_it_can_tell_if_all_ships_have_sunk
    assert_equal false, @kyle.has_lost?

    2.times {@kyle.ships[:submarine].hit}
    3.times {@kyle.ships[:cruiser].hit}

    assert_equal true, @kyle.has_lost?
  end

  def test_it_can_generate_computer_ship_placements
    @kyle.computer_ship_coordinates(@kyle.ships[:cruiser])
    p @kyle.ships[:cruiser]

    assert_equal 3, @kyle.ships[:cruiser].length
    assert_equal true, @kyle.board.valid_placement?(@kyle.ships[:cruiser],
                       @kyle.computer_ship_coordinates(@kyle.ships[:cruiser]))
  end

end
