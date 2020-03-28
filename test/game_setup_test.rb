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
     @player_board = Board.new
     @computer_board = Board.new
     @player_cruiser = Ship.new("Cruiser", 3)
     @computer_cruiser = Ship.new("Cruiser", 3)
     @player_submarine = Ship.new("Submarine", 2)
     @computer_submarine = Ship.new("Submarine", 2)
   end

   def test_it_exists
     assert_instance_of GameSetup, @game_setup
   end

   def test_start_game
     @game_setup.start_game
   end
 end
