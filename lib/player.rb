# frozen_string_literal: true

require 'colorize'

# Represents the users, responsible mainly for inserting disks in the board
class Player
  attr_reader :name, :disk

  def initialize(valid_colors: String.colors, board: Array.new(6) { Array.new(7) })
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

  def gets_column
    loop do
      column_num = input_column
      return column_num.to_i if column_num.match?(/^[0-6]$/) && !column_full?(column_num)

      puts 'Invalid column! You should type a number between 0-7, where the number represents a column that is not full!'
    end
  end

  def insert_disk
    column_num = gets_column
    5.downto(0) do |row_num|
      if @board[row_num][column_num].nil?
        @board[row_num][column_num] = disk
        break
      end
    end
  end

  private

  def input_column
    puts 'Type the number of the column: (0-6)'
    gets.chomp
  end

  def input_color
    valid_colors_str = @valid_colors.join(', ')
    puts "Valid colors: #{valid_colors_str}"
    print 'Insert your disk color: '
    gets.chomp.to_sym
  end

  def column_full?(col)
    !@board[0][col.to_i].nil?
  end
end
