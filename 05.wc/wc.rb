# frozen_string_literal: true

require 'optparse'

def main
  options = parse_options
  line_sum = word_sum = char_sum = 0

  ARGV.each do |item|
    line, word, char = calculate_and_print_counts(item, options)
    line_sum += line
    word_sum += word
    char_sum += char
  end

  display_total(line_sum, word_sum, char_sum, options) if ARGV.size > 1
end

def calculate_and_print_counts(item, options)
  text = File.read(item)
  line = text.count("\n")
  word = text.split.size
  char = text.bytesize

  result = []
  if options.empty?
    result << line.to_s.rjust(8)
    result << word.to_s.rjust(8)
    result << char.to_s.rjust(8)
  else
    result << line.to_s.rjust(8) if options[:l]
    result << word.to_s.rjust(8) if options[:w]
    result << char.to_s.rjust(8) if options[:c]
  end
  result = result.join('')
  puts "#{result} #{item}"

  [line, word, char]
end

def display_total(line_sum, word_sum, char_sum, options)
  result_sum = []
  result_sum << line_sum.to_s.rjust(8) if options.empty? || options[:l]
  result_sum << word_sum.to_s.rjust(8) if options.empty? || options[:w]
  result_sum << char_sum.to_s.rjust(8) if options.empty? || options[:c]
  result_sum = result_sum.join('')
  puts "#{result_sum} total"
end

def parse_options
  options = {}
  OptionParser.new do |opt|
    opt.on('-l', 'Count lines') { |l| options[:l] = l }
    opt.on('-w', 'Count words') { |w| options[:w] = w }
    opt.on('-c', 'Count bytes') { |c| options[:c] = c }
    opt.parse!(ARGV)
  end
  options
end

main
