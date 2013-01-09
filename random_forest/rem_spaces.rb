#!/usr/bin/env ruby

require 'wukong'
load '/home/dlaw/delay/scripts/columns.rb'
module Filter
  class Mapper < Wukong::Streamer::RecordStreamer
    include Columns::AfterFilter

    def process *line
      line[CARRIER] = line[CARRIER].gsub(' ','')
      line.delete_at ORIG_AIRPORT
      yield [line.join(',')]
    end
  end
end

Wukong::Script.new(
  Filter::Mapper,
  nil
).run
