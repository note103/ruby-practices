# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end

point = 0
frames.each_with_index do |frame, index|
  break if index == 10

  next_frame = frames[index + 1]
  if frame[0] == 10 # strike
    if next_frame[0] == 10
      point += 10 + next_frame[0] + frames[index + 2][0]
    else
      point += 10 + next_frame.sum
    end
  elsif frame.sum == 10 # spare
    point += 10 + next_frame[0]
  else
    point += frame.sum
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
