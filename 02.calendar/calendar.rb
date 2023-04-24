#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'date'

options = ARGV.getopts('m:y:')

month = options['m']&.to_i || Date.today.month
year = options['y']&.to_i || Date.today.year

cal_first_date = Date.new(year, month, 1)
cal_last_date = Date.new(year, month, -1)

puts "      #{month}月 #{year}"

top = %w[日 月 火 水 木 金 土]
puts top.join(' ')

cal = (cal_first_date..cal_last_date).to_a

BLANK_DATES = '  ' * cal_first_date.wday
SPACE_BETWEEN_DATES = cal_first_date.sunday? ? '' : ' ' * (cal_first_date.wday - 1)
print BLANK_DATES + SPACE_BETWEEN_DATES

cal.each do |c|
  cal_date = c.day.to_s.rjust(2)
  print ' ' unless c.sunday?
  print c == Date.today ? "\e[7m#{cal_date}\e[0m" : cal_date
  print "\n" if c.saturday?
end

print "\n"
