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

  def place_ship_prompt
    p "I have laid out my ships on the grid.\n
    You now need to lay out your two ships. \n
    The Cruiser is three units long and the Submarine is two units long."
  end
end
