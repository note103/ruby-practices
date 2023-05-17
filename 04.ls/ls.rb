# frozen_string_literal: true

SPACE_BETWEEN_COLUMNS = 1
COLUMN = 3

def main
  list = fetch_current_directory_contents
  print_columns_format(list)
end

def fetch_current_directory_contents
  contents = Dir.glob('*')
  contents.map { |item| File.ftype(item) == 'directory' ? "#{item}/" : item }
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
    row = i % rows
    col = i / rows
    grid[row][col] = l
  end
  grid
end

def print_formatted_grid(grid)
  grid.each do |row|
    puts row.join(' ')
  end
end

main
