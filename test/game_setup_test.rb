require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/game_setup'
require './lib/player'
require 'pry'

class GameSetupTest < Minitest::Test
   def setup
     @game_setup = GameSetup.new
   end

   def test_it_exists
     assert_instance_of GameSetup, @game_setup
   end

   def test_it_has_readable_attributes
     assert_instance_of Player, @game_setup.player
     assert_instance_of Player, @game_setup.computer
     assert_equal true, @game_setup.player.is_human?
     assert_equal false, @game_setup.computer.is_human?
   end

   def test_players_has_player_and_computer
     assert_equal [@game_setup.player, @game_setup.computer], @game_setup.players
   end

   def test_setup
     @game_setup.setup
   end
 end
