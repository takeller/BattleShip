class PlaceShips
attr_reader :player
  def initialize(player)
    @player = player
  end

  def computer_ship_coordinates(ship)
    coordinate_indexes = ship.length - 1
    placement_coordinates = []
    until @player.board.valid_placement?(ship, placement_coordinates)
      placement_coordinates = @player.board.cells.keys.shuffle[0..coordinate_indexes]
    end
    placement_coordinates
  end

  def computer_place_ships
    @player.ships.values.each do |ship|
      @player.board.place(ship, computer_ship_coordinates(ship))
    end
  end

  def user_input

    input = gets.chomp
  end

  def player_get_coordinates
    user_input.split(" ")
  end

  def starting_prompt
    prompt =  "I have laid out my ships on the grid.
    You now need to lay out your two ships.
    The #{@player.ships.values[0].name} is #{@player.ships.values[0].length} units long and the #{@player.ships.values[1].name} is #{@player.ships.values[1].length} units long."
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
