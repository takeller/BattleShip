require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/game_setup'
require 'pry'

class GameSetupTest < Minitest::Test
   def setup
     @game_setup = GameSetup.new
   end

   def test_it_exists
     assert_instance_of GameSetup, @game_setup
   end

   def test_start_game
     @game_setup.start_game
   end

   def test_valid_shot?
     assert_equal true, @game_setup.valid_shot(@game_setup.human_player.board, "A1")

     @game_setup.human_player.board.cells["A1"].fire_upon

     assert_equal false, @game_setup.valid_shot(@game_setup.human_player.board, "A1")
     assert_equal false, @game_setup.valid_shot(@game_setup.human_player.board, "E1")
   end

   def test_get_computer_shot
      assert_equal true, @game_setup.get_computer_shot.valid_shot?
   end

   def test_get_player_shot
     assert_equal true, @game_setup.get_player_shot.valid_shot?
   end

   def test_register_shots
     assert_equal false, @game_setup.human_player.board.cells["A1"].fired_upon?
     assert_equal false, @game_setup.computer_player.board.cells["D4"].fired_upon?

     @game_setup.human_player.board.cells["A1"].fire_upon
     @game_setup.computer_player.board.cells["D4"].fire_upon

     assert_equal true, @game_setup.human_player.board.cells["A1"].fired_upon?
     assert_equal true, @game_setup.computer_player.board.cells["D4"].fired_upon?
   end

   def test_shot_results
     # Player
     
   end
 end
