require './lib/cell'

describe Cell do
  subject(:valid_cell) { described_class.new('test') }

  context 'when ititialized with wrong number of arguemnt' do
    it 'raises an error' do
      expect { described_class.new }.to raise_error(ArgumentError)
      expect { described_class.new('some', 'arg') }.to raise_error(ArgumentError)
    end
  end

  context 'when initialized with one argument' do
    it 'does not raise an error' do
      expect { valid_cell }.not_to raise_error
    end

    it { is_expected.to have_attributes(id: 'test') }

    it { is_expected.to have_attributes(data: nil) }

    it { is_expected.to have_attributes(adjacent_cells: []) }
  end

  context '#add_adjacent_cells' do
    it 'assign passed array to @adjacent_cells' do
      valid_cell.add_adjacent_cells([1, 2, 3])
      expect(valid_cell.adjacent_cells).to eq([1, 2, 3])
    end
  end
end
