require './lib/cell'

describe Cell do
  subject(:valid_cell) { described_class.new }

  context '#initialize' do
    it { is_expected.to have_attributes(data: nil) }
  end
end
