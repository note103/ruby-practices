# frozen_string_literal: true

require 'optparse'

SPACE_BETWEEN_COLUMNS = 1
COLUMN = 3

def main
  options = parse_options
  filenames = options[:r] ? Dir.glob('*').reverse : Dir.glob('*')
  print_columns_format(filenames)
end

def parse_options
  options = {}
  OptionParser.new do |opt|
    opt.on('-a', 'Include hidden files') { |a| options[:a] = a }
    opt.on('-r', 'Reverse the order of the sort') { |r| options[:r] = r }
    opt.parse!(ARGV)
  end
  options
end

def print_columns_format(filenames)
  max_length = filenames.map(&:length).max
  formatted_filenames = filenames.map { |l| l.ljust(max_length + SPACE_BETWEEN_COLUMNS) }
  row_count = (filenames.size.to_f / COLUMN).ceil
  grid = create_grid_array(formatted_filenames, row_count)
  print_formatted_grid(grid)
end

def create_grid_array(filenames, row_count)
  grid = Array.new(row_count) { Array.new(COLUMN) }
  filenames.each_with_index do |l, i|
    column, row = i.divmod(row_count)
    grid[row][column] = l
  end
  grid
end

def print_formatted_grid(grid)
  grid.each do |row|
    puts row.join(' ')
  end
end

main
