#!/usr/bin/env ruby
# encoding:UTF-8

require 'wukong'

module AddSeqid
  class Mapper < Wukong::Streamer::RecordStreamer
    TABLE_FILE = '/home/dlaw/weather/final_table'

    def initialize
      f = File.open TABLE_FILE
      @map = {}
      f.each_line do |line|
         line = line.split
         range = (line[0].to_i..line[1].to_i)
         seqid = line[2]
         wban = line[3]
         @map[wban] ||= {}
         @map[wban][range] = seqid
      end
    end

    def get_seqid wban, year, month, day
      date = "#{year}#{month}#{day}".to_i
      return nil unless @map.has_key? wban
      @map[wban].keys.each do |range|
        if range.cover? date
          return @map[wban][range]
        end
      end
      nil
    end

    def process *line
      seqid = get_seqid line[0], line[1], line[2], line[3]
      unless seqid.nil?
        yield [seqid] + line
      else
        return
      end
    end
  end
end

Wukong::Script.new(
  AddSeqid::Mapper,
  nil
).run
