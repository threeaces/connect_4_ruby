require './lib/board'

describe Board do
  subject(:default_board) { described_class.new }

  context '#initialize' do
    it 'creates the grid with 6 rows' do
      expect(default_board.grid.length).to eq(6)
    end

    it 'creates 7 columns in each row' do
      default_board.grid.each { |row| expect(row.length).to eq(7) }
    end
  end

  context '#positions' do
    it 'returns adjacent cells relative positions' do
      expect(default_board.positions).to eq([[1, 0], [1, 1], [1, -1], [0, 1], [0, -1], [-1, 1], [-1, -1]])
    end
  end

  context '#get_cell' do
    it 'access cell by coordiate (row, column)' do
      expect(default_board.get_cell(1, 4)).to eq(default_board.grid[1][4])
      expect(default_board.get_cell(3, 0)).to eq(default_board.grid[3][0])
    end
  end

  context '#place_piece' do
    it 'mark the valid cell of the selected row' do
      board = Board.new
      board.place_piece(5, 2, 'O')
      expect(board.get_cell(5, 2).data).to eq('O')
    end
  end

  context '#find_valid_row' do
    it 'returns false if the column is full' do
      cell_with_data = double('cell', data: 'something')
      allow(default_board).to receive(:get_cell).and_return(cell_with_data)
      expect(default_board.find_valid_row(2)).to be false
    end
    it 'finds the lowest empty position in the column' do
      expect(default_board.find_valid_row(4)).to eq(5)
      default_board.place_piece(5, 4, 'X')
      expect(default_board.find_valid_row(4)).to eq(4)
    end
  end

  subject(:game_board) { described_class.new }
  let(:o) { double('cell', data: 'o') }
  let(:x) { double('cell', data: 'x') }
  let(:n) { double('cell', data: nil) }

  context '#win?' do
    it 'returns false when the column does not have 4 consecutive match' do
      grid = [
        [n, n, n, n, n, n, x],
        [x, n, n, x, o, o, x],
        [o, n, x, o, o, x, o],
        [x, x, o, x, o, x, x],
        [o, x, o, o, x, o, x],
        [o, x, o, o, x, o, x]
      ]
      allow(game_board).to receive(:grid).and_return(grid)
      expect(game_board.win?(1, 4, 'o')).to be false
    end

    it 'returns true when the column have 4 consecutive match' do
      grid = [
        [n, n, n, n, o, n, x],
        [x, n, n, x, o, o, x],
        [o, n, x, o, o, x, o],
        [x, x, o, x, o, x, x],
        [o, x, o, o, x, x, x],
        [o, x, o, o, x, x, x]
      ]
      allow(game_board).to receive(:grid).and_return(grid)
      expect(game_board.win?(0, 4, 'o')).to be true
    end

    it 'returns false when the row does not have 4 consecutive match' do
      game_board.grid[0] = [o, o, o, x, o, o, n]
      expect(game_board.win?(0, 5, 'o')).to be false
    end

    it 'returns true when the row has 4 consecutive match' do
      game_board.grid[1] = [o, x, x, x, x, n, n, n]
      expect(game_board.win?(1, 4, 'x')).to be true
    end

    it 'returns true when 4 consecutive cells are marked the same diagonally(1)' do
      grid = [
        [n, n, n, n, n, n, x],
        [x, n, n, x, o, o, x],
        [o, n, x, o, o, x, o],
        [x, x, o, x, o, x, x],
        [o, o, o, o, x, x, x],
        [x, x, o, o, x, o, x]
      ]
      allow(game_board).to receive(:grid).and_return(grid)
      expect(game_board.win?(1, 4, 'o')).to be true
    end

    it 'returns true when 4 consecutive cells are marked the same diagonally(2)' do
      grid = [
        [n, n, n, n, n, n, n],
        [x, x, n, x, o, o, n],
        [o, o, x, o, o, x, x],
        [x, o, x, x, o, x, x],
        [o, x, o, o, x, x, o],
        [o, x, o, x, o, o, o]
      ]
      allow(game_board).to receive(:grid).and_return(grid)
      expect(game_board.win?(1, 1, 'x')).to be true
    end
  end

  context '#draw?' do
    it 'returns false when not all cells are marked and no winner' do
      grid = [
        [n, n, n, n, n, n, x],
        [x, n, n, x, o, o, x],
        [o, n, x, o, o, x, o],
        [x, x, o, x, o, x, x],
        [o, x, o, o, x, o, x],
        [o, x, o, o, x, o, x]
      ]
      allow(game_board).to receive(:grid).and_return(grid)
      expect(game_board.draw?).to be false
    end

    it 'returns false when not all cells are marked and no winner' do
      grid = [
        [o, x, o, o, x, x, x],
        [x, o, o, x, o, o, x],
        [o, o, x, o, o, x, o],
        [x, o, o, x, o, x, x],
        [o, x, o, o, x, o, x],
        [o, x, o, o, x, o, x]
      ]
      allow(game_board).to receive(:grid).and_return(grid)
      expect(game_board.draw?).to be true
    end
  end

  context '#display' do
    it 'displays the grid' do
      grid = [
        [n, n, n, n, n, n, x],
        [x, n, n, x, o, o, x],
        [o, n, x, o, o, x, o],
        [x, x, o, x, o, x, x],
        [o, x, o, o, x, o, x],
        [o, x, o, o, x, o, x]
      ]
      allow(game_board).to receive(:grid).and_return(grid)
      expect { game_board.display }.to output("""
|     |     |     |     |     |     |  x  |
-------------------------------------------
|  x  |     |     |  x  |  o  |  o  |  x  |
-------------------------------------------
|  o  |     |  x  |  o  |  o  |  x  |  o  |
-------------------------------------------
|  x  |  x  |  o  |  x  |  o  |  x  |  x  |
-------------------------------------------
|  o  |  x  |  o  |  o  |  x  |  o  |  x  |
-------------------------------------------
|  o  |  x  |  o  |  o  |  x  |  o  |  x  |
-------------------------------------------
|  1  |  2  |  3  |  4  |  5  |  6  |  7  |
""").to_stdout
    end
  end
end
