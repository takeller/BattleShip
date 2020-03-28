class GameSetup

  # attr_reader :human_player, :computer_player
  #
  # def initialize

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
    # Perform setup
    # Loop turns until end condition met
  end

  # Where do these instance variables come from?
  def computer_ship_coordinates(ship)
    coordinate_indexes = ship.length - 1
    placement_coordinates = []
    until @computer_board.valid_placement?(ship, placement_coordinates)
      placement_coordinates = @computer_board.cells.keys.shuffle[0..coordinate_indexes]
    end
    placement_coordinates
  end

  # Setup framework
  def setup
    # Make ships
    # Make initial boards
    # Make players
    # Computer ship placement
    # Player ship placement
    # Return players with ships placed
  end

  def make_ships

  end

  def make_boards

  end

  def make_players
    player = Player.new()
  end

  def player_ship_placement

  end
  # Turn framework
  def turn
    # Display Boards
    display_boards
    # Player shot
    get_player_shot
    # Computer shot
    # Report player shot
    # Report computer shot
    report_shots
    # Print result of shots
  end

  def display_boards
    puts "=============PLAYER BOARD============="
    puts human_player.board.render(true)
    puts "=============COMPUTER BOARD============="
    puts computer_player.board.render
  end

  def get_player_shot
    puts "Enter the coordinate for your shot:"
    shot_coordinate = gets.chomp
    # Check if shot is on the board
    # Check if this position has already been fired upon
    until computer_player.board.valid_coordinate?(shot_coordinate) && computer_player.board.cell.fired_upon?(shot_coordinate) == false
      if computer_player.board.cell.fired_upon?(shot_coordinate) == true
        puts "You have already fired on this coordinate:"
        shot_coordinate = gets.chomp
      else
        puts "Please enter a valid coordinate:"
        shot_coordinate = gets.chomp
      end
    end
    shot_coordinate
  end

  def get_computer_shot

  end

  def report_shots
    computer_player.board.cells[get_player_shot].fire_upon
    human_player.board.cells[get_computer_shot].fire_upon
  end
end
