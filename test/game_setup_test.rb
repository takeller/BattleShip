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

   def test_setup

   end

   def test_valid_shot?
     assert_equal true, @game_setup.valid_shot?(@game_setup.player, "A1")

     @game_setup.player.board.cells["A1"].fire_upon

     assert_equal false, @game_setup.valid_shot?(@game_setup.player, "A1")
     assert_equal false, @game_setup.valid_shot?(@game_setup.player, "E1")
     assert_equal true, @game_setup.valid_shot?(@game_setup.player , @game_setup.get_computer_shot)
   end
   # feed list of known valid coordinates i.e. "A1" -> "D4" and test this
   # coordinate is one of those.
   def test_get_computer_shot
      assert_equal true, @game_setup.valid_shot?(@game_setup.player , @game_setup.get_computer_shot)
   end

   def test_get_player_shot
     skip
     assert_equal true, @game_setup.get_player_shot.valid_shot?
   end

   def test_register_shots
     assert_equal false, @game_setup.player.board.cells["A1"].fired_upon?
     assert_equal false, @game_setup.computer.board.cells["D4"].fired_upon?

     @game_setup.player.board.cells["A1"].fire_upon
     @game_setup.computer.board.cells["D4"].fire_upon

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
     @game_setup.computer.stubs(:computer_ship_coordinates).returns(["A2", "A3", "A4"])
     @game_setup.player.stubs(:get_player_coordinates).returns("A2 A3 A4").then.returns("D1 D2")

     @game_setup.computer.computer_place_ships
     @game_setup.player.player_place_ships
     @game_setup.register_shots(shot_coordinates)

     assert_equal "hit", @game_setup.shot_results[:player]
     assert_equal "hit", @game_setup.shot_results[:computer]

     @game_setup.stubs(:get_player_shot).returns("A3")
     @game_setup.stubs(:get_computer_shot).returns("A3")
     shot_coordinates = { player: @game_setup.get_player_shot, computer: @game_setup.get_computer_shot}
     @game_setup.register_shots(shot_coordinates)

     assert_equal "hit", @game_setup.shot_results[:player]
     assert_equal "hit", @game_setup.shot_results[:computer]

     @game_setup.stubs(:get_player_shot).returns("A4")
     @game_setup.stubs(:get_computer_shot).returns("A4")
     shot_coordinates = { player: @game_setup.get_player_shot, computer: @game_setup.get_computer_shot}
     @game_setup.register_shots(shot_coordinates)

     assert_equal "hit, and sunk their Cruiser", @game_setup.shot_results[:player]
     assert_equal "hit, and sunk their Cruiser", @game_setup.shot_results[:computer]

   end
 end
