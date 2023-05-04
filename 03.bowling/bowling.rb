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

frames = shots.each_slice(2).to_a

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
