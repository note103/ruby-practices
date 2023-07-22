# frozen_string_literal: true

require 'optparse'

def main
  options = parse_options
  ARGV.empty? ? handle_stdin(options) : handle_files(options)
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
  text_stats = analysis_text(text)
  max_length = calculate_max_digits(text_stats)
  puts format_counts(options, text_stats, max_length)
end

def handle_files(options)
  total_counts = { line: 0, word: 0, char: 0 }

  ARGV.each do |filename|
    text = File.read(filename)
    text_stats = analysis_text(text)

    max_length = calculate_max_digits(text_stats)
    puts format_counts(options, text_stats, max_length, filename)

    total_counts[:line] += text_stats[:line]
    total_counts[:word] += text_stats[:word]
    total_counts[:char] += text_stats[:char]
  end

  return unless ARGV.size > 1

  max_length = calculate_max_digits(total_counts)
  total = format_counts(options, total_counts, max_length)
  puts "#{total} total"
end

def analysis_text(text)
  {
    line: text.count("\n"),
    word: text.split.size,
    char: text.bytesize
  }
end

def format_counts(options, text_stats, max_length, filename = nil)
  result = []
  if options.empty?
    result = [text_stats[:line].to_s.rjust(max_length[:line]), text_stats[:word].to_s.rjust(max_length[:word]), text_stats[:char].to_s.rjust(max_length[:char])]
  else
    result << text_stats[:line].to_s.rjust(max_length[:line]) if options[:l]
    result << text_stats[:word].to_s.rjust(max_length[:word]) if options[:w]
    result << text_stats[:char].to_s.rjust(max_length[:char]) if options[:c]
  end
  result = result.join('')
  filename ? "#{result} #{filename}" : result
end

def calculate_max_digits(text_stats)
  max_length = { line: 8, word: 8, char: 8 }
  max_length[:line] = [max_length[:line], text_stats[:line].to_s.size].max
  max_length[:word] = [max_length[:word], text_stats[:word].to_s.size].max
  max_length[:char] = [max_length[:char], text_stats[:char].to_s.size].max
  max_length
end

main
