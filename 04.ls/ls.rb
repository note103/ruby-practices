# frozen_string_literal: true

require 'optparse'
require 'etc'

SPACE_BETWEEN_COLUMNS = 1
COLUMN = 3
FILE_TYPE_MAP = {
  'file' => '-',
  'directory' => 'd',
  'link' => 'l'
}.freeze

def main
  options = parse_options
  contents = current_directory_contents
  options[:l] ? print_long_format(contents) : print_columns_format(contents)
end

def parse_options
  options = {}
  OptionParser.new do |opt|
    opt.on('-a', 'Include hidden files') { |a| options[:a] = a }
    opt.on('-r', 'Reverse the order of the sort') { |r| options[:r] = r }
    opt.on('-l', 'Display detailed file information') { |l| options[:l] = l }
    opt.parse!(ARGV)
  end
  options
end

def current_directory_contents
  Dir.glob('*')
end

def print_long_format(contents)
  puts "total #{calculate_total_blocks}"

  contents.each do |file|
    file_stat = File.stat(file)
    print FILE_TYPE_MAP.fetch(file_stat.ftype, '?')
    print_permissions(file_stat)
    print " #{file_stat.nlink.to_s.rjust(3)}"
    print " #{Etc.getpwuid(file_stat.uid).name}"
    print " #{Etc.getgrgid(file_stat.gid).name}"
    print " #{file_stat.size.to_s.rjust(5)}"
    print " #{file_stat.mtime.strftime('%_m %e %H:%M')}"
    puts " #{file}"
  end
end

def calculate_total_blocks
  total_blocks = 0
  current_directory_contents.each do |file|
    total_blocks += File.stat(file).blocks
  end
  total_blocks
end

def print_permissions(file_stat)
  mode = file_stat.mode
  print_permissions_for_user_type(mode >> 6)
  print_permissions_for_user_type(mode >> 3)
  print_permissions_for_user_type(mode)
end

def print_permissions_for_user_type(mode)
  print(mode & 4 == 4 ? 'r' : '-')
  print(mode & 2 == 2 ? 'w' : '-')
  print(mode & 1 == 1 ? 'x' : '-')
end

def print_columns_format(contents)
  max_length = contents.map(&:length).max
  formatted_contents = contents.map { |l| l.ljust(max_length + SPACE_BETWEEN_COLUMNS) }
  row_count = (contents.size.to_f / COLUMN).ceil
  grid = create_grid_array(formatted_contents, row_count)
  print_formatted_grid(grid)
end

def create_grid_array(contents, row_count)
  grid = Array.new(row_count) { Array.new(COLUMN) }
  contents.each_with_index do |l, i|
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
