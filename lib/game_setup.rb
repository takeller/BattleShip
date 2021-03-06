class GameSetup
attr_reader :player, :computer, :player_placement, :computer_placement
  def make_players
    @player = Player.new(true)
    @computer = Player.new
    [@player, @computer]
  end

  def make_place_ships
    @computer_placement = PlaceShips.new(@computer)
    @player_placement = PlaceShips.new(@player)
    [@player_placement, @computer_placement]
  end

  def setup
    start_game
    @computer_placement.computer_place_ships
    @player_placement.player_place_ships
  end

  def turn
    display_boards
    shot_coordinates = {player: get_player_shot, computer: get_computer_shot}
    puts `clear`
    register_shots(shot_coordinates)
    report_shot_results(shot_coordinates)
  end

  def run_game
    make_players
    make_place_ships
    setup
    until @player.has_lost? || @computer.has_lost?
      turn
    end
    if @player.has_lost? && @computer.has_lost?
      p "Tie Game"
    elsif @player.has_lost?
      p "You lost to the computer"
    elsif @computer.has_lost?
      p "YOU WON!!!!"
    end
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
    shot_coordinate = user_input
    until valid_shot?(@computer, shot_coordinate)
      if @computer.board.valid_coordinate?(shot_coordinate) == false
        puts "Please enter a valid coordinate:"
        shot_coordinate = user_input
      elsif @computer.board.cells[shot_coordinate].fired_upon? == true
        puts "You have already fired on this coordinate:"
        shot_coordinate = user_input
      end
    end
    shot_coordinate
  end

  def get_cells_with_hits
    hits = @player.board.cells.values.select do |cell|
      cell.render == "H"
    end
    hits.map{|cell| cell.coordinate}
  end

  def is_adjacent?(pair)
    letter_ord_difference = (pair[1][0].ord - pair[0][0].ord).abs
    number_ord_difference = (pair[1][1].ord - pair[0][1].ord).abs
    total_difference = letter_ord_difference + number_ord_difference
    return true if total_difference == 1
    false
  end

  def get_computer_shot
    hit_cells = get_cells_with_hits
    shot_coordinate = @player.board.cells.keys.shuffle[0]
    if hit_cells.length != 0
      until is_adjacent?([hit_cells.shuffle[0],shot_coordinate]) && valid_shot?(@player, shot_coordinate)
        shot_coordinate = @player.board.cells.keys.shuffle[0]
      end
    else
      until valid_shot?(@player, shot_coordinate)
        shot_coordinate = @player.board.cells.keys.shuffle[0]
      end
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

  def user_input
    input = gets.chomp
  end
end
