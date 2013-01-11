#!/usr/bin/env ruby

$:.unshift "/home/dlaw/dev/wukong_og/lib"
$:.unshift "/home/dlaw/dev/gorillib/lib"

require 'wukong'
require 'wukong/streamer/encoding_cleaner'

module ExtractFlights
  class Mapper < Wukong::Streamer::Base
    include Wukong::Streamer::EncodingCleaner

    # split the csv line, and remove trailing commas
    def recordize line
      line.chomp(',').split(',') rescue nil
    end
   
    # remove quotes around string columns
    def process *line
      line.each { |col| col.gsub!('"','') }
      yield line
    rescue StandardError => e
      $stderr.write "Error during process\n"
      $stderr.write "line: #{line}"
    end
  end
end

Wukong::Script.new(
  ExtractFlights::Mapper,
  nil
).run
