class Player

  attr_reader :board, :human, :ships

  def initialize(human = false)
    @human = human
    @board = Board.new
    @ships = {
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
end
