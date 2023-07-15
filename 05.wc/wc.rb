# frozen_string_literal: true

require 'optparse'

def main
  options = parse_options
  total_count = { line_sum: 0, word_sum: 0, char_sum: 0 }
  ARGV.empty? ? handle_stdin(options) : handle_files(total_count, options)
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
  line, word, char = process_file(text)
  puts format_counts(line, word, char, options)
end

def handle_files(total_count, options)
  ARGV.each do |item|
    text = File.read(item)
    line, word, char = process_file(text)
    puts format_counts(line, word, char, options, item)

    total_count[:line_sum] += line
    total_count[:word_sum] += word
    total_count[:char_sum] += char
  end
  caluculate_total(total_count, options) if ARGV.size > 1
end

def process_file(text)
  line = text.count("\n")
  word = text.split.size
  char = text.bytesize
  [line, word, char]
end

def format_counts(line, word, char, options, filename = nil)
  result = []
  result << line.to_s.rjust(8) if options.empty? || options[:l]
  result << word.to_s.rjust(8) if options.empty? || options[:w]
  result << char.to_s.rjust(8) if options.empty? || options[:c]
  result = result.join('')
  filename ? "#{result} #{filename}" : result
end

def caluculate_total(total_count, options)
  total = format_counts(total_count[:line_sum], total_count[:word_sum], total_count[:char_sum], options)
  puts "#{total} total"
end

main
