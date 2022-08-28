# frozen_string_literal: true

require_relative 'player'
# Responsible for the logic of game
class Game
  def initialize
    @board = Array.new(7) { Array.new(6) }
    @players = create_players
  end

  def create_players
    players = []
    2.times do |i|
      print "Hello Player #{i + 1}. "
      players[i] = Player.new
    end
    players
  end
end
