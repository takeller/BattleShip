class Board

  attr_reader :board_cells
  def initialize
    @board_cells = {}
  end

  def cells
    letters_array = [*"A".."D"]
    numbers_array = [*"1".."4"]

    letters_array.each do |letter|
      numbers_array.each do |num|
        coordinate = letter + num
        @board_cells[coordinate] = Cell.new(coordinate)
      end
    end
    board_cells
  end

  def valid_coordinate?(coordinate)
    @board_cells.has_key?(coordinate)
  end

  def valid_placement?(ship, coordinates)
    return false if (coordinates.length != ship.length) or (consecutive_coordinates?(coordinates) == false)
    return false if (non_diagonal_coordinates?(coordinates) == false)
    coordinates.each do |coordinate|
      return false if valid_coordinate?(coordinate) == false
    end
    return false if ships_overlapping?(coordinates)
    true
  end

  def consecutive_coordinates?(coordinates)

    boolean_array = []
    coordinates.each_cons(2) do |pair|
      return false if pair[0] == pair[1]
      letter_ord_difference = pair[1][0].ord - pair[0][0].ord
      number_ord_difference = pair[1][1].ord - pair[0][1].ord
      if (letter_ord_difference == 1 || letter_ord_difference == 0) && (number_ord_difference == 1 || number_ord_difference == 0)
        boolean_array << true
      else
        boolean_array << false
      end
    end

    return false if boolean_array.any?(false)
    true
  end


  def non_diagonal_coordinates?(coordinates)
    check_diagonal_ords = []

    coordinates.each_cons(2) do |pair|
      letter_ord_difference = pair[1][0].ord - pair[0][0].ord
      number_ord_difference = pair[1][1].ord - pair[0][1].ord
      return false if letter_ord_difference > 1 or number_ord_difference > 1
      check_diagonal_ords << letter_ord_difference + number_ord_difference
    end

    return false if check_diagonal_ords.any? { |ord_diff_total| ord_diff_total > 1}
    true
  end

  def ships_overlapping?(coordinates)
    coordinates.map {|coordinate| @board_cells[coordinate].empty?}.any?(false)
  end


  def place(ship, coordinates)
    return "Invalid Placement" unless valid_placement?(ship, coordinates)
    coordinates.each do |coordinate|
      @board_cells[coordinate].place_ship(ship)
    end
  end
end
