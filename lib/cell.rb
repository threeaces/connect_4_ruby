class Cell
  attr_reader :id, :adjacent_cells
  attr_accessor :data

  def initialize(id)
    @id = id
    @data = nil
    @adjacent_cells = []
  end

  def add_adjacent_cells(cells)
    @adjacent_cells = cells
  end
end
