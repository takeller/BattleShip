class Board
  attr_reader :cells
  def initialize
    letters_array = [*"A".."D"]
    numbers_array = [*"1".."4"]
    @cells = {}
    letters_array.each do |letter|
      numbers_array.each do |num|
        coordinate = letter + num
        @cells[coordinate] = Cell.new(coordinate)
      end
    end
    @cells
  end

  def place(ship, coordinates)
    coordinates.each do |coordinate|
      @cells[coordinate].place_ship(ship)
    end
  end
end
