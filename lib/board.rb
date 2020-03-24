class Board

  def cells
    letters_array = [*"A".."D"]
    numbers_array = [*"1".."4"]

    board_cells = {}
    letters_array.each do |letter|
      numbers_array.each do |num|
        coordinate = letter + num
        board_cells[coordinate] = Cell.new(coordinate)
      end
    end
    board_cells
  end
end
