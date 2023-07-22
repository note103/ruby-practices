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
  puts format_counts(options, text_stats, max_length)
end

def handle_files(options)
  total_counts = { line: 0, word: 0, char: 0 }

  ARGV.each do |filename|
    text = File.read(filename)
    text_stats = analysis_text(text)

    puts format_counts(options, text_stats, max_length, filename)

    total_counts[:line] += text_stats[:line]
    total_counts[:word] += text_stats[:word]
    total_counts[:char] += text_stats[:char]
  end

  return unless ARGV.size > 1

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

end

main
