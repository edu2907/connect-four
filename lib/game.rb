# frozen_string_literal: true

require_relative 'player'

# Responsible for the logic of game
class Game
  attr_accessor :current_player, :board
  attr_reader :players

  def initialize
    @board = Array.new(6) { Array.new(7) }
    @players = create_players
    @current_player = @players[0]
    @round_n = 0
  end

  def create_players
    players = []
    valid_colors = String.colors
    valid_colors.delete(:default)
    2.times do |i|
      print "Hello Player #{i + 1}. "
      players[i] = Player.new(board: board, valid_colors: valid_colors)
    end
    players
  end

  def run
    loop do
      @round_n += 1
      execute_round
      game_over? ? break : next_player
    end
    draw? ? print_draw_msg : print_win_msg
  end

  def execute_round
    puts "Round #{@round_n}"
    print_board
    puts "#{players[0].disk} - #{players[0].name}\n#{players[1].disk} - #{players[1].name}"
    current_player.insert_disk
  end

  def draw?
    board.flatten.none?(&:nil?)
  end

  def game_over?; end

  def next_player
    @current_player = players.reject { |player| current_player == player }.first
  end

  def disks(space)
    space.nil? ? '⚪' : space
  end

  private

  def print_board
    board.each do |col|
      col.each do |space|
        print " #{disks(space)} "
      end
      puts ''
    end
  end

  def print_win_msg; end

  def print_draw_msg; end
end
