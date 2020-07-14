require_relative 'cell'

class Board
  attr_reader :grid, :positions

  def initialize
    @grid = create_grid
    @positions = get_adjacent_cells
  end

  def get_cell(row, column)
    grid[row][column]
  end

  def find_valid_row(column)
    5.downto(0) { |i| return i if get_cell(i, column).data.nil? }
    false
  end

  def place_piece(row, column, marker)
    get_cell(row, column).data = marker
  end

  def win?(row, column, marker)
    count = positions.map { |pos| match(row, column, pos, marker) }
    return true if count[0] >= 3
    return true if count[3] + count[4] >= 3
    return true if count[2] + count[5] >= 3
    return true if count[1] + count[6] >= 3
    false
  end

  def draw?
    grid.flatten.each { |cell| return false if cell.data.nil? }
    true
  end

  def display
    puts
    grid.each do |row|
      data_row = row.map do |cell|
        cell.data || ' '
      end
      puts "|  #{data_row.join('  |  ')}  |"
      puts '-------------------------------------------'
    end
    puts "|  #{[1, 2, 3, 4, 5, 6, 7].join('  |  ')}  |"
  end

  private

  def create_grid
    Array.new(6) { Array.new(7) { Cell.new } }
  end

  def get_adjacent_cells(cells = [])
    [1, 0, -1].each do |y|
      [0, 1, -1].each do |x|
        next if y.zero? && x.zero? || y == -1 && x.zero?

        cells << [y, x]
      end
    end
    cells
  end

  def off_board?(row, column)
    row > 5 || row < 0 || column > 6 || column < 0
  end

  def match(row, column, pos, marker, count = 0)
    row += pos[0]
    column += pos[1]
    return count if off_board?(row, column) || get_cell(row, column).data != marker

    count += 1
    match(row, column, pos, marker, count)
  end
end

# board = Board.new
# board.place_piece(0, 2, 'x')
# board.place_piece(1, 2, 'x')
# board.place_piece(2, 2, 'x')
# board.place_piece(3, 2, 'x')

# board.display
