require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/game_setup'
require './lib/player'
require 'pry'

class GameSetupTest < Minitest::Test
  def setup
    @game_setup = GameSetup.new
    @game_setup.make_players
  end

  def test_it_exists
    assert_instance_of GameSetup, @game_setup
  end

  def test_make_players
    @game_setup.make_players.each do |player|
      assert_instance_of Player, player
    end
  end

  def test_valid_shot?
    assert_equal true, @game_setup.valid_shot?(@game_setup.player, "A1")

    @game_setup.player.board.cells["A1"].fire_upon

    assert_equal false, @game_setup.valid_shot?(@game_setup.player, "A1")
    assert_equal false, @game_setup.valid_shot?(@game_setup.player, "E1")
    assert_equal true, @game_setup.valid_shot?(@game_setup.player , @game_setup.get_computer_shot)
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
    @game_setup.stubs(:computer_ship_coordinates).returns(["A2", "A3", "A4"])
    @game_setup.stubs(:user_input).returns("A2 A3 A4").then.returns("D1 D2")

    @game_setup.computer_place_ships
    @game_setup.player_place_ships
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

  def test_it_can_generate_computer_ship_placements
   cruiser = @game_setup.computer.ships[:cruiser]
   submarine = @game_setup.computer.ships[:submarine]
   @game_setup.computer_ship_coordinates(cruiser)

   assert_equal 3, @game_setup.computer_ship_coordinates(cruiser).count
   assert_equal 2, @game_setup.computer_ship_coordinates(submarine).count
   assert_equal true, @game_setup.computer.board.valid_placement?(cruiser,
                      @game_setup.computer_ship_coordinates(cruiser))
   assert_equal true, @game_setup.computer.board.valid_placement?(submarine,
                      @game_setup.computer_ship_coordinates(submarine))
  end

  def test_computer_can_place_ships
   assert_nil @game_setup.computer.board.cells["B2"].ship
   assert_nil @game_setup.computer.board.cells["C2"].ship
   assert_nil @game_setup.computer.board.cells["D2"].ship
   assert_nil @game_setup.computer.board.cells["D3"].ship
   assert_nil @game_setup.computer.board.cells["D4"].ship

   @game_setup.stubs(:computer_ship_coordinates).returns(["B2", "C2", "D2"]).then.returns(["D3", "D4"])
   @game_setup.computer_place_ships
   cruiser = @game_setup.computer.ships[:cruiser]
   submarine = @game_setup.computer.ships[:submarine]
   assert_equal cruiser, @game_setup.computer.board.cells["B2"].ship
   assert_equal cruiser, @game_setup.computer.board.cells["C2"].ship
   assert_equal cruiser, @game_setup.computer.board.cells["D2"].ship
   assert_equal submarine, @game_setup.computer.board.cells["D3"].ship
   assert_equal submarine, @game_setup.computer.board.cells["D4"].ship
  end

  def test_it_gets_the_starting_prompt
   expected = "I have laid out my ships on the grid.
    You now need to lay out your two ships.
    The Cruiser is 3 units long and the Submarine is 2 units long."
   assert_equal expected, @game_setup.starting_prompt
  end

  def test_player_get_coordinates_turns_input_to_an_array
   @game_setup.stubs(:user_input).returns ("A1 A2 A3")
   assert_equal ["A1", "A2", "A3"], @game_setup.player_get_coordinates
  end

  def test_check_valid_coordinates_only_passes_valid_coordinates
   @game_setup.stubs(:user_input).returns("A1 A2 A7").then.returns(("A1 A2 A3"))
   cruiser = @game_setup.player.ships[:cruiser]

   assert_equal ["A1", "A2", "A3"], @game_setup.check_valid_coordinates(cruiser)

   @game_setup.stubs(:user_input).returns("B4 V2 Z33").then.returns("B1 C1")
   submarine = @game_setup.player.ships[:submarine]
   assert_equal ["B1", "C1"], @game_setup.check_valid_coordinates(submarine)
  end

  def test_players_can_place_ships
   cruiser = @game_setup.player.ships[:cruiser]
   submarine = @game_setup.player.ships[:submarine]

   assert_nil @game_setup.player.board.cells["A1"].ship
   assert_nil @game_setup.player.board.cells["A2"].ship
   assert_nil @game_setup.player.board.cells["A3"].ship
   assert_nil @game_setup.player.board.cells["B1"].ship
   assert_nil @game_setup.player.board.cells["C1"].ship

   @game_setup.stubs(:user_input).returns("A1 A2 A3").then.returns("B1 C1")
   @game_setup.player_place_ships

   assert_equal cruiser, @game_setup.player.board.cells["A1"].ship
   assert_equal cruiser, @game_setup.player.board.cells["A2"].ship
   assert_equal cruiser, @game_setup.player.board.cells["A3"].ship
   assert_equal submarine, @game_setup.player.board.cells["B1"].ship
   assert_equal submarine, @game_setup.player.board.cells["C1"].ship
  end
end
