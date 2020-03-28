cd B  class GameSetup

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

  def computer_ship_placement(ship)
    coordinate_indexes = ship.length - 1
    placement_coordinates = []
    until @computer_board.valid_placement?(ship, placement_coordinates)
      placement_coordinates = @computer_board.cells.keys.shuffle[0..coordinate_indexes]
    end
    placement_coordinates
  end
end
