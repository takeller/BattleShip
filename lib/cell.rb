require 'pry'
class Cell

  attr_reader :coordinate, :ship
  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
  end

  def fired_upon?
    @fired_upon
  end

  def empty?
    ship == nil
  end

  def place_ship(ship)
    @ship = ship
  end

# We shouldn't be able to fire upon the same cell twice
  def fire_upon
    @fired_upon = true
    unless empty?
      @ship.hit
    end
  end

  def render(show_ship = false)
    return "S" if show_ship == true && (fired_upon? == false && empty? == false)
    if fired_upon? == false
      "."
    elsif fired_upon? && empty?
      "M"
    elsif fired_upon? && ship.sunk?
      "X"
    elsif fired_upon? && empty? == false
      "H"
    end
  end

end
