#!/usr/bin/env ruby

require 'wukong'

module Filter
  class Mapper < Wukong::Streamer::LineStreamer

    def process line
      yield [line] 
    end
  end
end

Wukong::Script.new(
  Filter::Mapper,
  nil
).run
