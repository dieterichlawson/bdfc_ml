#!/usr/bin/env ruby

require 'wukong'
require 'wukong/parser/flatpack_parser'

unless File.exist? 'mshr_enhanced.txt'
  `curl -L 'http://www.ncdc.noaa.gov/homr/file/mshr_enhanced.txt.zip' > mshr_enhanced.zip`
  `unzip mshr_enhanced.zip && mv mshr_enhanced_*.txt mshr_enhanced.txt`
  `rm mshr_enhanced.zip`
end

unless File.exist? 'mshr_enhanced.tsv'
  MSHR_FORMAT_STRING = '_20 _10 s8 s8 _20 _20 _20 s20 s20 _687 s2 _*'

  mshr_parser = Wukong::Parser::FlatPack.create_parser(MSHR_FORMAT_STRING,1)
  mshr_parser.file_to_tsv('mshr_enhanced.txt','mshr_enhanced.tsv')

  `rm mshr_enhanced.txt`
end

`uniq mshr_enhanced.tsv > mshr_enhanced.tsv.tmp`

in_file = File.open 'mshr_enhanced.tsv.tmp'
id_map = {}
in_file.each_line do |line|
  line = line[0..-2].split "\t"
  next unless line[2] != '' and line[3] != '' and line[4] == 'US'
  start_date, end_date, wban, faa_id = line 
  start_date = start_date.to_i ; end_date = end_date.to_i
  id_map[wban] ||= {} ; id_map[wban][faa_id] ||= []
  found_coverage = false
  id_map[wban][faa_id].each_with_index do |range,index|
    if range.cover? start_date
      id_map[wban][faa_id][index] = (range.first..end_date)
      found_coverage = true
      break
    end
  end
  id_map[wban][faa_id] << (start_date..end_date) unless found_coverage
end

out_file = File.open 'mshr_enhanced.tsv','w'

id_map.keys.each do |wban|
  if id_map[wban].keys.length == 1
    out_file.puts [10101, 99991231, wban, id_map[wban].keys[0]].join "\t"
    next
  end
  id_map[wban].keys.each do |faa_id|
    id_map[wban][faa_id].each do |range|
      out_file.puts [range.first, range.end, wban, faa_id].join "\t"
    end
  end
end

in_file.close ; out_file.close
`rm mshr_enhanced.tsv.tmp`
`sort -k 4 mshr_enhanced.tsv > mshr_enhanced.tsv.tmp && mv mshr_enhanced.tsv.tmp mshr_enhanced.tsv`
