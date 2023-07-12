# frozen_string_literal: true

require 'optparse'

def main
  options = parse_options
  line_sum = word_sum = char_sum = 0

  ARGV.each do |item|
    line, word, char = process_file(item, options)
    line_sum += line
    word_sum += word
    char_sum += char
  end

  return unless ARGV.size > 1

  total = format_counts(line_sum, word_sum, char_sum, options)
  puts "#{total} total"
end

def process_file(item, options)
  text = File.read(item)
  line = text.count("\n")
  word = text.split.size
  char = text.bytesize

  result = format_counts(line, word, char, options)
  puts "#{result} #{item}"

  [line, word, char]
end

def format_counts(line, word, char, options)
  result = []
  result << line.to_s.rjust(8) if options.empty? || options[:l]
  result << word.to_s.rjust(8) if options.empty? || options[:w]
  result << char.to_s.rjust(8) if options.empty? || options[:c]
  result.join('')
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
