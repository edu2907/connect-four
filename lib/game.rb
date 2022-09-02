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
      if game_over?
        print_win_msg
        break
      elsif draw?
        print_draw_msg
        break
      end

      next_player
    end
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

  def game_over?
    horizontal_line? || vertical_line? || diagonal_line? || reverse_diagonal_line?
  end

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

  # For each row, verifys if a line of 4 spaces is equal to "match_line"
  def horizontal_line?
    match_line = Array.new(4, @current_player.disk)
    board.any? do |row|
      0.upto(3).any? do |start_col|
        end_col = start_col + 3
        row.slice(start_col..end_col) == match_line
      end
    end
  end

  # For each column, verifys if a line of 4 spaces is equal to "match_line"
  def vertical_line?
    match_line = Array.new(4, @current_player.disk)
    0.upto(6).any? do |col_n|
      0.upto(2).any? do |start_row|
        end_row = start_row + 3
        vertical_arr = board.slice(start_row..end_row).map { |row| row[col_n] }
        vertical_arr == match_line
      end
    end
  end

  def diagonal_line?
    match_line = Array.new(4, @current_player.disk)
    0.upto(2).any? do |row_n|
      0.upto(3).any? do |col_n|
        diagonal_arr = [board[row_n][col_n], board[row_n + 1][col_n + 1], board[row_n + 2][col_n + 2],
                        board[row_n + 3][col_n + 3]]
        diagonal_arr == match_line
      end
    end
  end

  def reverse_diagonal_line?
    match_line = Array.new(4, @current_player.disk)
    0.upto(2).any? do |row_n|
      0.upto(3).any? do |col_n|
        diagonal_arr = [board[row_n][col_n + 3], board[row_n + 1][col_n + 2], board[row_n + 2][col_n + 1],
                        board[row_n + 3][col_n]]
        diagonal_arr == match_line
      end
    end
  end

  def print_win_msg; end

  def print_draw_msg; end
end
