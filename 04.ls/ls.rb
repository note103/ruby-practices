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
  filenames = Dir.glob('*')
  options[:l] ? print_long_format(filenames) : print_columns_format(filenames)
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

def print_long_format(filenames)
  puts "total #{calculate_total_blocks}"

  filenames.each do |file|
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
  Dir.glob('*').each do |file|
    total_blocks += File.stat(file).blocks if File.file?(file)
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
