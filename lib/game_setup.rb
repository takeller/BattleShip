class GameSetup
attr_reader :player, :computer
  def make_players
    @player = Player.new(true)
    @computer = Player.new
  end

  # def players
  #   [@player, @computer]
  # end

  def run_game
    make_players
    setup

    until @player.has_lost? || @computer.has_lost?
      turn
    end

    p "You lost to the computer" if @player.has_lost?
    p "YOU WON!!!!" if @computer.has_lost?

    run_game
  end

  def main_menu
    p "Welcome to BATTLESHIP"
    p  "Enter p to play. Enter q to quit"
    input = user_input
    until input == "p" || input == "q"
      p  "Enter p to play. Enter q to quit"
      input = user_input
    end
    input
  end

  def start_game
    exit! if main_menu == "q"
    # Perform setup
    # Loop turns until end condition met
  end

  def setup #need better testing
    start_game
    computer_place_ships
    player_place_ships
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
    report_shot_results(shot_coordinates)
  end

  def display_boards
    puts "=============PLAYER BOARD============="
    puts @player.board.render(true)
    puts "=============COMPUTER BOARD============="
    puts @computer.board.render
  end

  def valid_shot?(player,coordinate)
    player.board.valid_coordinate?(coordinate) && player.board.cells[coordinate].fired_upon? == false
  end

  def get_player_shot
    puts "Enter the coordinate for your shot:"
    shot_coordinate = gets.chomp
    # Check if shot is on the board
    # Check if this position has already been fired upon
    # I think I need to pass the shot_coordinate to the cell
    until valid_shot?(@computer, shot_coordinate)
      if @computer.board.valid_coordinate?(shot_coordinate) == false
        puts "Please enter a valid coordinate:"
        shot_coordinate = gets.chomp
      elsif @computer.board.cells[shot_coordinate].fired_upon? == true
        puts "You have already fired on this coordinate:"
        shot_coordinate = gets.chomp
      end
    end
    shot_coordinate
  end

  # Fires on random spot on the board that has not already been fired_upon
  def get_computer_shot
    shot_coordinate = @player.board.cells.keys.shuffle[0]
    # require 'pry'; binding.pry
    until valid_shot?(@player, shot_coordinate)
      # require 'pry'; binding.pry
      shot_coordinate = @player.board.cells.keys.shuffle[0]
    end
    shot_coordinate
  end

  def register_shots(shot_coordinates)
    @computer.board.cells[shot_coordinates[:player]].fire_upon
    @player.board.cells[shot_coordinates[:computer]].fire_upon
  end

  def shot_results(shot_coordinates)
    results = {}
    if @computer.board.cells[shot_coordinates[:player]].empty?
      results[:player] = "miss"
    elsif @computer.board.cells[shot_coordinates[:player]].ship.sunk?
      results[:player] = "hit, and sunk their #{@computer.board.cells[shot_coordinates[:player]].ship.name}"
    else
      results[:player] = "hit"
    end

    if @player.board.cells[shot_coordinates[:computer]].empty?
      results[:computer] = "miss"
    elsif @player.board.cells[shot_coordinates[:computer]].ship.sunk?
      results[:computer] = "hit, and sunk our #{@player.board.cells[shot_coordinates[:computer]].ship.name}"
    else
      results[:computer] = "hit"
    end
    results
  end

  def report_shot_results(shot_coordinates)
    puts "Computer shot on #{shot_coordinates[:computer]} was a #{shot_results(shot_coordinates)[:computer]}."
    puts "My shot on #{shot_coordinates[:player]} was a #{shot_results(shot_coordinates)[:player]}."
  end

  def computer_ship_coordinates(ship)
    coordinate_indexes = ship.length - 1
    placement_coordinates = []
    until @computer.board.valid_placement?(ship, placement_coordinates)
      placement_coordinates = @computer.board.cells.keys.shuffle[0..coordinate_indexes]
    end
    placement_coordinates
  end

  def computer_place_ships
    @computer.ships.values.each do |ship|
      @computer.board.place(ship, computer_ship_coordinates(ship))
    end
  end

  def starting_prompt
    prompt =  "I have laid out my ships on the grid.
    You now need to lay out your two ships.
    The #{@player.ships.values[0].name} is #{@player.ships.values[0].length} units long and the #{@player.ships.values[1].name} is #{@player.ships.values[1].length} units long."
  end

  def user_input
    input = gets.chomp
  end

  def player_get_coordinates
    user_input.split(" ")
  end

  def check_valid_coordinates(ship) #needs better testing
    coordinates = player_get_coordinates
    until @player.board.valid_placement?(ship, coordinates)
      puts "Those are invalid coordinates. Please try again:"
      coordinates = player_get_coordinates
    end
    coordinates
  end

  def player_place_ships
    puts starting_prompt
    puts @player.board.render(true)
    @player.ships.values.each do |ship|
      puts "enter the squares for the #{ship.name} (#{ship.length} spaces:)"
      coordinates = check_valid_coordinates(ship)
      @player.board.place(ship, coordinates)
      puts @player.board.render(true)
    end
  end
end
