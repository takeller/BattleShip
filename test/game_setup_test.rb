require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/game_setup'
require './lib/player'
require './lib/place_ships'
require 'pry'

class GameSetupTest < Minitest::Test
  def setup
    @game_setup = GameSetup.new
    @game_setup.make_players
    @game_setup.make_place_ships
  end

  def test_it_exists
    assert_instance_of GameSetup, @game_setup
  end

  def test_make_players
    @game_setup.make_players.each do |player|
      assert_instance_of Player, player
    end
  end

  def test_make_place_ships
    @game_setup.make_place_ships do |placement|
      assert_instance_of PlaceShips, placement
    end
  end

  def test_valid_shot?
    assert_equal true, @game_setup.valid_shot?(@game_setup.player, "A1")

    @game_setup.player.board.cells["A1"].fire_upon

    assert_equal false, @game_setup.valid_shot?(@game_setup.player, "A1")
    assert_equal false, @game_setup.valid_shot?(@game_setup.player, "E1")
    assert_equal true, @game_setup.valid_shot?(@game_setup.player , @game_setup.get_computer_shot)
  end

  def test_it_can_get_cells_with_hits
    assert_equal [], @game_setup.get_cells_with_hits

    cruiser = @game_setup.player.ships[:cruiser]
    submarine = @game_setup.player.ships[:submarine]
    @game_setup.player_placement.stubs(:user_input).returns("A1 A2 A3").then.returns("B1 C1")
    @game_setup.player_placement.player_place_ships
    @game_setup.player.board.cells["A1"].fire_upon
    @game_setup.player.board.cells["B1"].fire_upon
    assert_equal ["A1", "B1"], @game_setup.get_cells_with_hits

    @game_setup.player.board.cells["C1"].fire_upon
    assert_equal ["A1"], @game_setup.get_cells_with_hits
  end

  def test_it_can_tell_adjacent_coordinates
    assert_equal true, @game_setup.is_adjacent?(["A1", "A2"])
    assert_equal true, @game_setup.is_adjacent?(["A2", "A1"])
    assert_equal true, @game_setup.is_adjacent?(["C2", "B2"])
    assert_equal true, @game_setup.is_adjacent?(["B4", "C4"])
    assert_equal false, @game_setup.is_adjacent?(["A4", "C4"])
    assert_equal false, @game_setup.is_adjacent?(["A2", "A4"])
  end

  def test_get_computer_shot
     assert_equal true, @game_setup.valid_shot?(@game_setup.player , @game_setup.get_computer_shot)
  end

  def test_get_player_shot
    @game_setup.stubs(:user_input).returns("A1")
    assert_equal "A1", @game_setup.get_player_shot
  end

  def test_register_shots
    assert_equal false, @game_setup.player.board.cells["A1"].fired_upon?
    assert_equal false, @game_setup.computer.board.cells["D4"].fired_upon?

    @game_setup.stubs(:get_player_shot).returns("D4")
    @game_setup.stubs(:get_computer_shot).returns("A1")

    shot_coordinates = {player: @game_setup.get_player_shot,
                        computer: @game_setup.get_computer_shot}
    @game_setup.register_shots(shot_coordinates)

    assert_equal true, @game_setup.player.board.cells["A1"].fired_upon?
    assert_equal true, @game_setup.computer.board.cells["D4"].fired_upon?
  end

  def test_shot_results
    @game_setup.stubs(:get_player_shot).returns("A1")
    @game_setup.stubs(:get_computer_shot).returns("A1")

    shot_coordinates = {player: @game_setup.get_player_shot,
                        computer: @game_setup.get_computer_shot}
    @game_setup.register_shots(shot_coordinates)

    assert_equal "miss", @game_setup.shot_results(shot_coordinates)[:player]
    assert_equal "miss", @game_setup.shot_results(shot_coordinates)[:computer]

    @game_setup.stubs(:get_player_shot).returns("A2")
    @game_setup.stubs(:get_computer_shot).returns("A2")

    shot_coordinates = {player: @game_setup.get_player_shot, computer: @game_setup.get_computer_shot}
    @game_setup.computer_placement.stubs(:computer_ship_coordinates).returns(["A2", "A3", "A4"])
    @game_setup.player_placement.stubs(:user_input).returns("A2 A3 A4").then.returns("D1 D2")
    @game_setup.computer_placement.computer_place_ships
    @game_setup.player_placement.player_place_ships
    @game_setup.register_shots(shot_coordinates)

    assert_equal "hit", @game_setup.shot_results(shot_coordinates)[:player]
    assert_equal "hit", @game_setup.shot_results(shot_coordinates)[:computer]

    @game_setup.stubs(:get_player_shot).returns("A3")
    @game_setup.stubs(:get_computer_shot).returns("A3")
    shot_coordinates = { player: @game_setup.get_player_shot, computer: @game_setup.get_computer_shot}
    @game_setup.register_shots(shot_coordinates)

    assert_equal "hit", @game_setup.shot_results(shot_coordinates)[:player]
    assert_equal "hit", @game_setup.shot_results(shot_coordinates)[:computer]

    @game_setup.stubs(:get_player_shot).returns("A4")
    @game_setup.stubs(:get_computer_shot).returns("A4")
    shot_coordinates = { player: @game_setup.get_player_shot, computer: @game_setup.get_computer_shot}
    @game_setup.register_shots(shot_coordinates)

    assert_equal "hit, and sunk their Cruiser", @game_setup.shot_results(shot_coordinates)[:player]
    assert_equal "hit, and sunk our Cruiser", @game_setup.shot_results(shot_coordinates)[:computer]
  end
end
