#!/usr/bin/env ruby
# encoding:UTF-8

require 'wukong'

module SplitTimes
  class Mapper < Wukong::Streamer::RecordStreamer
    def process *line

    end
  end
end

Wukong::Script.new(
  SplitTimes::Mapper,
  nil
).run
