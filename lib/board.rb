class Board
  attr_reader :cells
  def initialize
    @cells = make_cells
  end

  def make_cells
    grid = make_grid
    board_cells = {}
    grid.each do |coordinate|
      board_cells[coordinate] = Cell.new(coordinate)
    end
    board_cells
  end

  def valid_coordinate?(coordinate)
    @cells.has_key?(coordinate)
  end

  def valid_placement?(ship, coordinates)
    return false if same_plane?(coordinates) == false
    return false if coordinates.length != ship.length
    return false if consecutive_coordinates?(coordinates) == false
    coordinates.each do |coordinate|
      return false if valid_coordinate?(coordinate) == false
    end
    return false if ships_overlapping?(coordinates)
    true
  end

  def letters_same?(coordinates)
    letters = coordinates.map{|coordinate| coordinate[0]}
    letters.uniq.length == 1
  end

  def numbers_same?(coordinates)
    nums = coordinates.map{|coordinate| coordinate[1..-1]}
    nums.uniq.length == 1
  end

  def same_plane?(coordinates)
    numbers_same?(coordinates) || letters_same?(coordinates)
  end

  def consecutive_coordinates?(coordinates)
    check_ord_difference = []
    coordinates.each_cons(2) do |pair|
      return false if pair[0] == pair[1]
      letter_ord_difference = pair[1][0].ord - pair[0][0].ord
      number_ord_difference = pair[1][1].ord - pair[0][1].ord
      if (letter_ord_difference == 1 || letter_ord_difference == 0) && (number_ord_difference == 1 || number_ord_difference == 0)
        check_ord_difference << true
      else
        check_ord_difference << false
      end
    end

    return false if check_ord_difference.any?(false)
    true
  end

  def make_grid
    letters = [*"A".."D"]
    numbers = [*"1".."4"]
    grid = []
    letters.each do |letter|
      numbers.each do |num|
        grid << letter + num
      end
    end
    grid
  end

  def render(show_ship = false)
    if show_ship == false
      size = 4
      grid = make_grid
      grid_of_cells = grid.map { |coordinate| @cells[coordinate]  }

      row2 = grid_of_cells[0..3].map { |cell| cell.render}
      row3 = grid_of_cells[4..7].map { |cell| cell.render}
      row4 = grid_of_cells[8..11].map { |cell| cell.render}
      row5 = grid_of_cells[12..15].map { |cell| cell.render}
      rendered_board =  ("  1 2 3 4 \n"  + "A #{row2.join(" ")} \n" + "B #{row3.join(" ")} \n" + "C #{row4.join(" ")} \n" + "D #{row5.join(" ")} \n")
    elsif show_ship == true
      size = 4
      grid = make_grid
      grid_of_cells = grid.map { |coordinate| @cells[coordinate]  }

      row2 = grid_of_cells[0..3].map { |cell| cell.render(true)}
      row3 = grid_of_cells[4..7].map { |cell| cell.render(true)}
      row4 = grid_of_cells[8..11].map { |cell| cell.render(true)}
      row5 = grid_of_cells[12..15].map { |cell| cell.render(true)}

      rendered_board =  ("  1 2 3 4 \n"  + "A #{row2.join(" ")} \n" + "B #{row3.join(" ")} \n" + "C #{row4.join(" ")} \n" + "D #{row5.join(" ")} \n")
    end
    rendered_board
  end

  def ships_overlapping?(coordinates)
  coordinates.map {|coordinate|  @cells[coordinate].empty?}.any?(false)
  end


  def place(ship, coordinates)
    return "Invalid Placement" unless valid_placement?(ship, coordinates)
    coordinates.each do |coordinate|
      @cells[coordinate].place_ship(ship)
    end
  end
end
