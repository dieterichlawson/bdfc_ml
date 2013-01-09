#!/usr/bin/env ruby
# encoding: UTF-8

require 'wukong'
load '/home/dlaw/weather/prep_weather/flatpack_streamer.rb'
load '/home/dlaw/dev/wukong/lib/wukong/streamer/encoding_cleaner.rb'

module Weather
  class Mapper < Wukong::Streamer::FlatPackStreamer
    include Wukong::Streamer::EncodingCleaner
    #       241121997 01 01 07   100    30  9995   240    26     7 -9999 -9999
    #       241121997 01 01 00    60     0 10059   230    57     7 -9999     0
    #       241121997 01 01 06   100    30  9997   230    87     7 -9999     0
    format 's5   s4  _s2_s2_s2s6    s6    s6    s6    s6    s6    s6    s*    '

    def process *line
      yield line
    end

  end
end

Wukong::Script.new(Weather::Mapper, nil).run
