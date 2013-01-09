#!/usr/bin/env ruby
# encoding:UTF-8

require 'wukong'
require 'date'
load '/home/dlaw/delay/scripts/columns.rb'

module AddArrival
  class Mapper < Wukong::Streamer::RecordStreamer
    include Columns::SplitTimes

    def process *line
      dep_time = DateTime.new(line[YEAR].to_i,line[MONTH].to_i,line[DAY].to_i,line[SCHED_DEP_HR].to_i,line[SCHED_DEP_MIN].to_i)
      dep_mins = (line[SCHED_ELAPSED_TIME].to_f/1440.0)
      dep_time += dep_mins
      line.insert(SCHED_ARR_HR, "%02d" % dep_time.day)
      line.insert(SCHED_ARR_HR, "%02d" % dep_time.month)
      line.insert(SCHED_ARR_HR, dep_time.year)
      yield line
    end
  end
end

Wukong::Script.new(
  AddArrival::Mapper,
  nil
).run
