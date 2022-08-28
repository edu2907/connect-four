# frozen_string_literal: true

require_relative 'player'
# Responsible for the logic of game
class Game
  attr_accessor :current_player
  attr_reader :players

  def initialize
    @board = Array.new(7) { Array.new(6) }
    @players = create_players
    @current_player = @players[0]
  end

  def create_players
    players = []
    2.times do |i|
      print "Hello Player #{i + 1}. "
      players[i] = Player.new
    end
    players
  end

  def run
    until game_over?
      execute_round
      next_player
    end
  end

  def next_player
    @current_player = players.reject { |player| current_player == player }.first
  end
end
