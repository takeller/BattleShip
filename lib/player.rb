class Player

  attr_reader :board, :human, :ships

  def initialize(human = false)
    @human = human
    @board = Board.new
    @ships =
    {
    cruiser: Ship.new("Cruiser", 3),
    submarine: Ship.new("Submarine", 2)
    }
  end

  def is_human?
    @human
  end

  def has_lost?
    @ships.values.map { |ship| ship.sunk? }.all?
  end

  def computer_ship_coordinates(ship)
    coordinate_indexes = ship.length - 1
    placement_coordinates = []
    until board.valid_placement?(ship, placement_coordinates)
      placement_coordinates = board.cells.keys.shuffle[0..coordinate_indexes]
    end
    placement_coordinates
  end

  def computer_place_ships
    @ships.values.each do |ship|
      @board.place(ship, computer_ship_coordinates(ship))
    end
  end

  def user_input
    coordinates = gets.chomp
    # coordinates.split(" ")
  end
  def player_get_coordinates
    user_input.split(" ")
  end

  def starting_prompt
    prompt =  "I have laid out my ships on the grid.
    You now need to lay out your two ships.
    The #{@ships.values[0].name} is #{@ships.values[0].length} units long and the #{@ships.values[1].name} is #{@ships.values[1].length} units long."
  end

  def check_valid_coordinates(ship) #needs better testing
    coordinates = player_get_coordinates
    until board.valid_placement?(ship, coordinates)
      puts "Those are invalid coordinates. Please try again:"
      coordinates = player_get_coordinates
    end
    coordinates
  end

  def player_place_ships #needs better testing
    puts starting_prompt
    puts @board.render(true)
    @ships.values.each do |ship|
      puts "enter the squares for the #{ship.name} (#{ship.length} spaces:)"
      coordinates = check_valid_coordinates(ship)
      @board.place(ship, coordinates)
      puts @board.render(true)
    end
  end
end
