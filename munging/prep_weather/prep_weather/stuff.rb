#!/usr/bin/env ruby

require 'set'

pairs = {}

f = File.open '/home/dlaw/weather/final_table'
f.each_line do |line|
  line = line.split
  wban = line[3]
  seq_id = line[2]
  if pairs.has_key? wban and pairs[wban] != seq_id
    puts "found difference #{wban} <-> #{seq_id} #{pairs[wban]}"
    puts line
  else
    pairs[wban] = seq_id
  end

end
