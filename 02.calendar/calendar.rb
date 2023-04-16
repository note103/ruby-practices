#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'optparse'
require 'date'

# オプションの受け取り
options = ARGV.getopts('m:y:')

# オプションで受け取った`m`, `y`をそれぞれ数値に変換
month = options['m'].to_i
year = options['y'].to_i

# 月と年のオブジェクト生成
month = Date.today.month if month == 0
year = Date.today.year if year == 0

# 指定された月の初日・最終日を変数に格納
cal_first_date = Date.new(year, month, 1)
cal_last_date = Date.new(year, month, -1)

# 最終日の数値を変数`last_date`に格納
last_date = cal_last_date.day

# 実行した日のオブジェクト生成
today = Date.today

# 指定された月が実行した日を含む場合はフラグ`this_month_flag`に1を代入
this_month_flag = 0
if today.month == month && today.year == year
  this_month_flag = 1
end

# 1行目に表示する年月表示を作成・表示
month = month.to_s
puts "      #{month}月 #{year}"

# 2行目に表示する曜日行を作成・表示
top = %w[日 月 火 水 木 金 土]
puts top.join(" ")

# 表示する1ヶ月分の日にちを配列で作成
cal = (1..last_date).to_a

# 表示する1ヶ月分の日にち（数字）にハッシュで曜日を割り当て
cal_hash = {}
i = cal_first_date.wday
cal.each do |c|
  cal_hash[c] = i
  if i < 6
    i += 1
  else
    i = 0
  end
end

# 変数`today_date`に実行した日の数字を代入（反転表示の準備）
today_date = today.day.to_s

# カレンダーの日付部分の作成・表示
# ハッシュからeachメソッドで日にち・曜日をループ開始
cal_hash.each do |cal_date, cal_day|

  # 日にちを文字列化
  cal_date = cal_date.to_s

  # 日にちが1桁なら頭に半角スペースを付ける
  if /\A\d\z/.match(cal_date)
    cal_date = " " + cal_date
  end

  # 1日の曜日によって1日の位置を空白で調整
  # 1日が日曜日の場合は調整不要なのでif文でその旨の条件指定
  if cal_date == " 1" && cal_day != 0
    print "  " * cal_day + " " * (cal_day - 1)
  end

  # 日曜以外は日にちの前に数字同士の間に入る半角スペースを挿入
  print " " if cal_day != 0
  # 実行日の場合は日にちを反転（`\e[7m`）
  print "\e[7m" if this_month_flag == 1 && cal_date == today_date
  # 日にちを出力
  print cal_date
  # 実行日の場合は反転をリセット（`\e[7m`）
  print "\e[0m" if this_month_flag == 1 && cal_date == today_date
  # 土曜の場合は日にちの後に改行
  print "\n" if cal_day == 6
end

# 最後に改行
print "\n"
