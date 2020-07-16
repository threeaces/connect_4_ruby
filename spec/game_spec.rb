require './lib/game'

describe Game do
  subject(:default_game) { described_class.new }
  let(:player1) { double('player', name: 'John', marker: 'O') }
  let(:player2) { double('player', name: 'Jane', marker: 'X') }
  subject(:game) { described_class.new([player1, player2]) }

  context '#initialize' do
    it 'adds two player objects' do
      allow_any_instance_of(described_class).to receive(:gets).and_return('test')
      allow_any_instance_of(described_class).to receive(:puts)
      expect(default_game.players.length).to eq(2)
      expect(default_game.players[0].class).to eq(Player)
      expect(default_game.players[1].class).to eq(Player)
    end
  end

  context '#switch_players' do
    it 'change the order of players' do
      expect(game.players).to eq([player1, player2])
      game.switch_players
      expect(game.players).to eq([player2, player1])
    end
  end

  context '#prompt_move' do
    it 'warns until number input 1-7 is received' do
      allow(game).to receive(:gets).and_return('not valid', 'still not valid', '4')
      expect(game).to receive(:puts).with('Please enter a valid column').twice
      game.prompt_move
    end

    it 'warns if full column is selected' do
      game =  described_class.new([player1, player2])
      board = double('board')
      game.instance_variable_set(:@board, board)
      allow(game).to receive(:gets).and_return('6', '5')
      allow(board).to receive(:find_valid_row).and_return(false, 2)
      expect(game).to receive(:puts).with('The column is full. Please pick different column').once
      game.prompt_move
    end

    it 'does not warn again if valid number received and selected column is not full' do
      board = double('board')
      game.instance_variable_set(:@board, board)
      allow(board).to receive(:find_valid_row).and_return(2)
      allow(game).to receive(:gets).and_return('3')
      expect(game).not_to receive(:puts).with('Please enter a valid column')
      game.prompt_move
    end

    it 'returns the valid input received and selected column is not full' do
      board = double('board')
      game.instance_variable_set(:@board, board)
      allow(board).to receive(:find_valid_row).and_return(3)
      allow(game).to receive(:gets).and_return('7')
      expect(game.prompt_move).to eq('7')
    end
  end
end
