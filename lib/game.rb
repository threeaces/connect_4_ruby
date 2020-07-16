require_relative 'board'
require_relative 'cell'
require_relative 'player'

class Game
  attr_reader :board, :players

  def initialize(players = add_players)
    @board = Board.new
    @players = players
  end

  def switch_players
    players[0], players[1] = players[1], players[0]
  end

  def prompt_move
    loop do
      input = gets.chomp
      if !valid?(input)
        puts 'Please enter a valid column'
      elsif full?(input)
        puts 'The column is full. Please pick different column'
      else
        return input
      end
    end
  end

  def play
    board.display
    loop do
      puts "#{players[0].name}, please select a column to place your piece"
      column = prompt_move.to_i - 1
      row = board.find_valid_row(column)
      board.place_piece(row, column, players[0].marker)
      board.display
      if board.win?(row, column, players[0].marker)
        puts "#{players[0].name} won!"
        break
      elsif board.draw?
        puts 'Game has ended in a tie'
        break
      else
        switch_players
      end
    end
  end

  private

  def add_players(game_players = [])
    2.times do |i|
      puts "Player #{i + 1}, please enter your name"
      name = gets.chomp
      marker = i.zero? ? 'O' : 'X'
      game_players << Player.new(name, marker)
      puts "#{name}, your piece is #{marker}"
    end
    game_players
  end

  def valid?(input)
    input.match?(/^[1-7]$/)
  end

  def full?(input)
    board.find_valid_row(input.to_i - 1) == false
  end
end

game = Game.new
game.play