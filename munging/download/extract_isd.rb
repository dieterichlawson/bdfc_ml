#!/usr/bin/env ruby
# encoding: UTF-8

require 'wukong'
load '/home/dlaw/dev/wukong_og/lib/wukong/streamer/flatpack_streamer.rb'
load '/home/dlaw/dev/wukong_og/lib/wukong/parser/flatpack_parser.rb'

module Weather
  class Mapper < Wukong::Streamer::FlatPackStreamer
    #       241121997 01 01 07   100    30  9995   240    26     7 -9999 -9999
    #       241121997 01 01 00    60     0 10059   230    57     7 -9999     0
    #       241121997 01 01 06   100    30  9997   230    87     7 -9999     0
    format 'i5   i4  _i2_i2_i2D6e1  D6e1  D6e1  D6e0  D6e1  i6    D6e1  D6e1  '
  end
end

Wukong::Script.new(Weather::Mapper, nil).run
