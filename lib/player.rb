class Player

  attr_reader :board, :name

  def initialize(name, board, ships)
    @name = name
    @board = board
    @ships = ships
  end

  def all_ships_sunk?
    return true if ships.all? { |ship| ship.sunk?  }
  end

end
