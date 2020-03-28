class Player

  attr_reader :board, :name, :ships

  def initialize(name)
    @name = name
    @board = Board.new
    @ships = {
              cruiser: Ship.new("Cruiser", 3),
              submarine: Ship.new("Submarine", 2)
              }
  end

  def has_lost?
    ships.values.map { |ship| ship.sunk? }.all?
  end

  def computer_ship_coordinates(ship)
    coordinate_indexes = ship.length - 1
    placement_coordinates = []
    until board.valid_placement?(ship, placement_coordinates)
      placement_coordinates = board.cells.keys.shuffle[0..coordinate_indexes]
    end
    placement_coordinates
  end

end
