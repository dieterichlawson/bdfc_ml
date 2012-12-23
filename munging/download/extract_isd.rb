#!/usr/bin/env ruby
# encoding: UTF-8

require 'wukong'
require 'wukong/streamer/flatpack_streamer'

module Weather
  class Mapper < Wukong::Streamer::FlatPackStreamer
    include Wukong::Streamer::EncodingCleaner

    #       241121997 01 01 07   100    30  9995   240    26     7 -9999 -9999
    #       241121997 01 01 00    60     0 10059   230    57     7 -9999     0
    format 'i5   i4  _i2_i2_i2D6e1  D6e1  D6e1  D6e0  D6e1  i6    D6e1  D6e1  '
  end
end

Wukong::Script.new(Weather::Mapper, nil).run
