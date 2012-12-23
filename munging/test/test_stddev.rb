#!/usr/bin/env ruby
require 'descriptive_statistics'

N = 5000000
SPLITS = 5
SPLIT_WIDTH = N/SPLITS
numbers = []
(1..N).each do |num|
  numbers << Random.rand * 100.0
end

#create the files
(1..SPLITS).each do |num|
  `rm nums_#{num}`
  f = File.open "nums_#{num}",'w'
  start = (num-1)*SPLIT_WIDTH
  puts "going #{start} to #{start + SPLIT_WIDTH-1}"
  (start...start+SPLIT_WIDTH).each do |index|
    f.puts numbers[index]
  end
  f.close
end

(1..SPLITS).each do |num|
  `cat nums_#{num} | ./stddev.rb --map > mapoutput_#{num}`
end
puts `cat mapoutput_* | ./stddev.rb --reduce`
`rm mapoutput_*`
`rm nums_*`
puts numbers.mean
puts numbers.standard_deviation
