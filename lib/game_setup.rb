class GameSetup
  attr_reader :player, :computer

  def initialize
    @player = Player.new(true)
    @computer = Player.new
  end

  def players
    [@player, @computer]
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
    # Perform setup
    # Loop turns until end condition met
  end

  def setup #need better testing
    start_game
    @computer.computer_place_ships
    @player.player_place_ships
  end

  # Turn framework
  def turn
    # Display Boards
    display_boards
    # Player shot
    # Computer shot
    shot_coordinates = {player: get_player_shot, computer: get_computer_shot}
    # Report player shot
    # Report computer shot
    register_shots(shot_coordinates)
    # Print result of shots
    report_shot_results
  end

  def display_boards
    puts "=============PLAYER BOARD============="
    puts human_player.board.render(true)
    puts "=============COMPUTER BOARD============="
    puts computer_player.board.render
  end

  def valid_shot?(board,coordinate)
    board.valid_coordinate?(coordinate) && board.cells(coordinate).fired_upon? == false
  end

  def get_player_shot
    puts "Enter the coordinate for your shot:"
    shot_coordinate = gets.chomp
    # Check if shot is on the board
    # Check if this position has already been fired upon
    # I think I need to pass the shot_coordinate to the cell
    until valid_shot?(computer_player.board, shot_coordinate)
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

  # Fires on random spot on the board that has not already been fired_upon
  def get_computer_shot
    shot_coordinate = human_player.board.cells.keys.shuffle
    until valid_shot?(human_player.board, shot_coordinate)
      shot_coordinate = human_player.board.cells.keys.shuffle
    end
  end

  def register_shots(shot_coordinates)
    computer_player.board.cells[shot_coordinates[:player]].fire_upon
    human_player.board.cells[shot_coordinates[:computer]].fire_upon
  end

  def shot_results(shot_coordinates)
    results = {}
    if computer_player.board.cells[shot_coordinates[:player]].empty?
      results[:player] = "miss"
    elsif computer_player.board.cells[shot_coordinates[:player]].ship.sunk? 
      results[:player] = "hit, and sunk their #{computer_player.board.cells[shot_coordinates[:player]].ship}"
    else
      results[:player] = "hit"
    end

    if human_player.board.cells[shot_coordinates[:computer]].empty?
      results[:computer] = "miss"
    elsif human_player.board.cells[shot_coordinates[:computer]].ship.sunk?
      results[:computer] = "hit, and sunk their #{human_player.board.cells[shot_coordinates[:computer]].ship}"
    else
      results[:computer] = "hit"
    end
    results
  end

  def report_shot_results
    puts "Computer shot on #{shot_coordinate} was a #{shot_results[:computer]}."
    puts "My shot on #{shot_coordinate} was a #{shot_results[:player]}."
  end

end
