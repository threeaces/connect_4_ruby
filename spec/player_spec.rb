require './lib/player'

describe Player do
  context 'when initialized with worng number of argument' do
    it 'raises an error' do
      expect { described_class.new }.to raise_error(ArgumentError)
      expect { described_class.new('test') }.to raise_error(ArgumentError)
    end
  end

  context 'when initialized with two arguments' do
    subject(:valid_player) { described_class.new('Someone', 'X') }

    it 'does not raise an error' do
      expect { subject }.not_to raise_error
    end

    it { is_expected.to have_attributes(name: 'Someone') }

    it { is_expected.to have_attributes(marker: 'X') }
  end
end
