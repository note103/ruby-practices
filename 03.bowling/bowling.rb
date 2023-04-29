#!/usr/bin/env ruby
# frozen_string_literal: true

input_score = ARGV[0]
scores = input_score.split(',')

shots = []
scores.each do |score|
  if score == 'X'
    shots << 10
    shots << 0
  else
    shots << score.to_i
  end
end

frames = []
shots.each_slice(2) do |shot|
  frames << shot
end

point = 0
frames.each_with_index do |frame, index|
  break if index == 10

  next_frame = frames[index + 1]
  point += if frame[0] == 10 # strike
             if next_frame[0] == 10
               10 + next_frame[0] + frames[index + 2][0]
             else
               10 + next_frame.sum
             end
           elsif frame.sum == 10 # spare
             10 + next_frame[0]
           else
             frame.sum
           end
end

puts point

__END__
確認用データ
139: ruby bowling.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5
164: ruby bowling.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X
107: ruby bowling.rb 0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4
134: ruby bowling.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0
144: ruby bowling.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8
300: ruby bowling.rb X,X,X,X,X,X,X,X,X,X,X,X

# scores = %w[6 3 9 0 0 3 8 2 7 3 X 9 1 8 0 X 6 4 5] # 139
# scores = %w[6 3 9 0 0 3 8 2 7 3 X 9 1 8 0 X X X X] # 164
# scores = %w[0 10 1 5 0 0 0 0 X X X 5 1 8 1 0 4] # 107
# scores = %w[6 3 9 0 0 3 8 2 7 3 X 9 1 8 0 X X 0 0] # 134
# scores = %w[6 3 9 0 0 3 8 2 7 3 X 9 1 8 0 X X 1 8] # 144
# scores = %w[X X X X X X X X X X X X] # 300
