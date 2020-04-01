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

  def has_lost?
    @ships.values.map { |ship| ship.sunk? }.all?
  end
end
