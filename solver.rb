require 'byebug'

class Solver

  def initialize(file)
    @board = File.readlines(file).map { |line| line.chomp.split('') }
    start = get_coords('S')
    @finish = get_coords('E')
    @current = start
    @covered = [start]
  end

  def get_coords(char)
    @board.each_with_index do |row, ri|
      return [ri,row.index(char)] if row.index(char)
    end
  end

  def run

    until finished?
      display
      move = get_frontier.min_by { |coords| score(coords) }
      make_move(move)
    end

    display
  end

  def finished?
    @current == @finish
  end

  def make_move(coords)
    unless wall?(coords)
      @covered << @current
      @current = coords
    end
  end

  def get_frontier
    frontier = []
    x, y = @current
    [[-1, 0], [0, -1], [1, 0], [0, 1]].each do |x_shift, y_shift|
      coords = [x + x_shift, y + y_shift]
      frontier << coords unless wall?(coords) || @covered.include?(coords)
    end
    raise 'No where to go' if frontier.empty?
    frontier
  end

  def wall?(coords)
    x, y = coords
    in_bounds(coords) && @board[x][y] == '*'
  end

  def in_bounds(coords)
    x, y = coords
    x.between?(0,@board.count) && y.between?(0, @board.first.count)
  end

  def score(coords)
    sx, sy = coords
    ex, ey = @finish
    Math.sqrt((sx - ex).abs2 + (sy - ey).abs2)
  end

  def render
    @board.each_with_index.map do |row, ri|
      row.each_with_index.map do |cell, ci|
        @covered.include?([ri, ci]) ? '#' : cell
      end.join()
    end
  end

  def display
    puts render
    puts ''
  end

end

if __FILE__ == $PROGRAM_NAME
  solver = Solver.new(ARGV[0])
  solver.run
end
