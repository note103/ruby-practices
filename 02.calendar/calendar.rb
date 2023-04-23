#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'date'

# オプションの受け取り
options = ARGV.getopts('m:y:')

# オプションで受け取った`m`, `y`をそれぞれ数値に変換
month = options['m']&.to_i || Date.today.month
year = options['y']&.to_i || Date.today.year

# 指定された月の初日・最終日を変数に格納
cal_first_date = Date.new(year, month, 1)
cal_last_date = Date.new(year, month, -1)

# 1行目に表示する年月表示を作成・表示
puts "      #{month}月 #{year}"

# 2行目に表示する曜日行を作成・表示
top = %w[日 月 火 水 木 金 土]
puts top.join(' ')

# 表示する1ヶ月分の日にちを配列で作成
cal = (cal_first_date..cal_last_date).to_a

# 1日の曜日によって1日の位置を空白で調整
# 1日が日曜日の場合は調整不要なのでif文でその旨の条件指定
print '  ' * cal_first_date.wday + ' ' * (cal_first_date.wday - 1) unless cal_first_date.sunday?

cal.each do |c|
  # 日にちが1桁なら1スペース分右寄せする
  cal_date = c.day.to_s.rjust(2)
  # 日曜以外は日にちの前に日付同士の間に入る半角スペースを挿入
  print ' ' unless c.sunday?
  # 実行日の場合は反転（`\e[7m`）
  print "\e[7m" if c == Date.today
  # 日にちを出力
  print cal_date
  # 実行日の場合は反転をリセット（`\e[7m`）
  print "\e[0m" if c == Date.today
  # 土曜の場合は日にちの後に改行
  print "\n" if c.saturday?
end

# 最後に改行
print "\n"
