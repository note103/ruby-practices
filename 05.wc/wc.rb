# frozen_string_literal: true

require 'optparse'

def main
  options = parse_options
  total_count = { line_sum: 0, word_sum: 0, char_sum: 0 }
  ARGV.empty? ? handle_stdin(options) : handle_files(options, total_count)
end

def parse_options
  options = {}
  OptionParser.new do |opt|
    opt.on('-l', 'Count lines') { options[:l] = true }
    opt.on('-w', 'Count words') { options[:w] = true }
    opt.on('-c', 'Count bytes') { options[:c] = true }
    opt.parse!(ARGV)
  end
  options
end

def handle_stdin(options)
  text = $stdin.read
  process_and_print_results(text, options)
end

def handle_files(options, total_count)
  ARGV.each do |filename|
    text = File.read(filename)
    line, word, char = process_and_print_results(text, options, filename)

    total_count[:line_sum] += line
    total_count[:word_sum] += word
    total_count[:char_sum] += char
  end
  caluculate_total(options, total_count) if ARGV.size > 1
end

def process_and_print_results(text, options, filename = nil)
  line, word, char = process_file(text)
  puts format_counts(options, line, word, char, filename)
  [line, word, char]
end

def process_file(text)
  line = text.count("\n")
  word = text.split.size
  char = text.bytesize
  [line, word, char]
end

def format_counts(options, line, word, char, filename = nil)
  result = []
  if options.empty?
    result = [line.to_s.rjust(8), word.to_s.rjust(8), char.to_s.rjust(8)]
  else
    result << line.to_s.rjust(8) if options[:l]
    result << word.to_s.rjust(8) if options[:w]
    result << char.to_s.rjust(8) if options[:c]
  end
  result = result.join('')
  filename ? "#{result} #{filename}" : result
end

def caluculate_total(options, total_count)
  total = format_counts(options, total_count[:line_sum], total_count[:word_sum], total_count[:char_sum])
  puts "#{total} total"
end

main
