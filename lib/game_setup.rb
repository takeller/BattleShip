class GameSetup
  def initialize
    @board = Board.new
    @player_cruiser = Ship.new("Cruiser", 3)
    @computer_cruiser = Ship.new("Cruiser", 3)
    @player_submarine = Ship.new("Submarine", 2)
    @computer_submarine = Ship.new("Submarine", 2)
  end

  def main_menu
    p "Welcome to BATTLESHIP"
    p  "Enter p to play. Enter q to quit"
    user_input = gets.chomp
    until user_input == "p" || user_input == "q"
      p  "Enter p to play. Enter q to quit"
      user_input = gets.chomp
    end
    user_input
  end

  def start_game
    exit! if main_menu == "q"
  end

  def setup

  end

end
