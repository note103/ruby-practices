# frozen_string_literal: true

SPACE_BETWEEN_COLUMNS = 1
COLUMN = 3

def main
  list = Dir.glob('*')
  print_columns_format(list)
end

def print_columns_format(list)
  max_length = list.map(&:length).max
  formatted_list = list.map { |l| l.ljust(max_length + SPACE_BETWEEN_COLUMNS) }
  rows = (list.size.to_f / COLUMN).ceil
  grid = create_grid_array(formatted_list, rows)
  print_formatted_grid(grid)
end

def create_grid_array(list, rows)
  grid = Array.new(rows) { Array.new(COLUMN) }
  list.each_with_index do |l, i|
    column, row = i.divmod(rows)
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
