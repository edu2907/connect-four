# frozen_string_literal: true

require 'colorize'

# Represents the users, responsible mainly for inserting disks in the board
class Player
  attr_reader :name, :disk

  def initialize(valid_colors:, board: [])
    @valid_colors = valid_colors
    @name = gets_name
    @disk = gets_disk
    @board = board
  end

  def gets_name
    print 'Insert your name: '
    gets.chomp.capitalize
  end

  def gets_disk
    color = gets_color
    '⚫'.colorize(color: color)
  end

  def gets_color
    loop do
      color = input_color
      if @valid_colors.include?(color)
        @valid_colors.delete(color)
        return color
      else
        puts 'Invalid color! The color should be one of the valid colors and cannot be a repeated color!'
      end
    end
  end

  def insert_disk; end

  def input_color
    valid_colors_str = @valid_colors.join(', ')
    puts "Valid colors: #{valid_colors_str}"
    print 'Insert your disk color: '
    gets.chomp.to_sym
  end
end
