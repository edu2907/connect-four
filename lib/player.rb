# frozen_string_literal: true

# Represents the users, responsible mainly for inserting disks in the board
class Player
  def initialize
    @name = gets_name
  end

  def gets_name
    print 'Insert your name: '
    gets.chomp
  end
end
