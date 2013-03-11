#!/usr/bin/env ruby

load 'rowgen.rb'
require_relative '../columns/final_single_city.rb'


N = 5000
SPLITS = 5
SPLIT_WIDTH = N/SPLITS

puts 'Generating data...'
rowgen = Munging::RowGenerator.new Columns.types
rows = []
(1..N).each do
  rows << rowgen.get_row
end

`mkdir -p data/orig data/tmp data/discretized data/normalized`
`rm data/*/*`

#create the files
puts 'Writing data to filesystem...'
(1..SPLITS).each do |num|
  `rm data/orig/part_#{num} 2>/dev/null`
  f = File.open "data/orig/part_#{num}",'w'
  start = (num-1)*SPLIT_WIDTH
  (start...start+SPLIT_WIDTH).each do |index|
    f.puts rows[index]
  end
  f.close
end

puts 'Describing the dataset...'
(1..SPLITS).each do |num|
  `cat data/orig/part_#{num} | ../describe/describe_data.rb --map --partition_col=4 > data/tmp/mapoutput_#{num}`
end
`cat data/tmp/mapoutput_* | sort -n -k 1 | ../describe/describe_data.rb --reduce --partition_col=4 > data/orig/dataset.info`

`rm data/tmp/*`
