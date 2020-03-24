require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require 'pry'

class BoardTest < Minitest::Test

  def setup
    @board = Board.new
  end

  def test_it_exists
    assert_instance_of Board, @board
  end

  def test_cells
    assert_equal 16, @board.cells.length
    @board.cells.each do |key, value|
      assert_instance_of Cell, value
    end
  end
end
