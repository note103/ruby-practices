#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'optparse'
require 'date'

options = ARGV.getopts('m:y:')
month = options['m'].to_i
year = options['y'].to_i

month = Date.today.month if month == 0
year = Date.today.year if year == 0

fdate = Date.new(year, month, 1)
ldate = Date.new(year, month, -1)
last_date = ldate.day

month = month.to_s
month = " " + month if (/\A\d\z/).match(month)
puts "      #{month}月 #{year}"

top = %w[日 月 火 水 木 金 土]
puts top.join(" ")


cal = (1..last_date).to_a
cal_hash = {}
i = fdate.wday
cal.each do |c|
  cal_hash[c] = i
  if i < 6
    i += 1
  else
    i = 0
  end
end

result = ""
cal_hash.each do |k, v|
  k = k.to_s
  if /\A\d\z/.match(k)
    k = " " + k
  end

  if k == " 1"
    result = "  " * v + " " * (v - 1)
  end

  if v == 6
    result = result + " " + k + "\n"
  elsif v == 0
    result = result + k
  else
    result = result +  " " + k
  end
end
print result + "\n"


__END__

# options = ARGV.getopts('m:y:')
# month = options['m'].to_i
# year = options['y'].to_i

month = 4
year = 2023
fdate = Date.new(year, month, 1)
ldate = Date.new(year, month, -1)
lastdate = ldate.strftime("%e")
p lastdate.class
p ldate.saturday?
p ldate.day.class
p fdate.wday
p ldate.wday

if fdate.wday == 6
  cal_fdate = " 1\n"
end
p cal_fdate
cal_second_week = (2..8).to_a
j = cal_second_week.join
cal = cal_fdate + j
p cal

month = month.to_s
month = "" + month if (/\A\d\z/).match(month)
puts "      #{month}月 #{year}"

top = %w[日 月 火 水 木 金 土]
puts top.join(" ")





__END__
fdate = Date.new(year, month, 1)

wday = {
  1 => "月",
  2 => "火",
  3 => "水",
  4 => "木",
  5 => "金",
  6 => "土",
  7 => "日"
}
fday = wday[fdate.cwday]
p fday

__END__

wday = {
  1 => "月",
  2 => "火",
  3 => "水",
  4 => "木",
  5 => "金",
  6 => "土",
  7 => "日"
}
lday = Date.new(year, month, -1)
lastday = lday.strftime("%e")
lastday = lastday.to_i

# puts "#{fday} - #{wday[fday.cwday]}"
# puts "#{lday} - #{wday[lday.cwday]}"

# cal = {}
# c = 1
# (1..lastday).each do |r|
#   cal[r] = wday[Date.new(year, month, r).cwday]
#   c  += 1
# end
# p cal

# cal.each do |k, v|
#   k = k.to_s
#   if v == "土"
#     k = k + "\n"
#     p k
#     # cal[:k] = v
#   end
# end
# p cal

# p cal

# foo = {}
# foo[:ruby] = "good"
# p foo
# hash = { Ruby: "foo"}
# p hash[:Ruby]

# days = (1..lastday).to_a.join(" ")
# p days
# puts top[0]
# puts top[1]

# p Date.today
# ld = "#{lday}"
# l = ld.match(/\d\d\z/)
# puts l

# days = (1..31).to_a.join(" ")
# days = (1..31).to_a

# cal = {}
# w = 1
# days.each do |d|
#   if d <= l.to_s.to_i
#     cal[d] = wday[fday.cwday]
#     d += 1
#     w += 1
#   end
# end
# p cal
# 
