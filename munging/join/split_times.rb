#!/usr/bin/env ruby
# encoding:UTF-8

require 'wukong'
load '/home/dlaw/delay/scripts/columns.rb'

module SplitTimes
  class Mapper < Wukong::Streamer::RecordStreamer
    include Columns::Final

    def process *line
      arr_t = line[SCHED_ARR_TIME]
      dep_t = line[SCHED_DEP_TIME]
      arr_hr = arr_t[0..1]
      arr_min = arr_t[2..3]
      dep_hr = dep_t[0..1]
      dep_min = dep_t[2..3]
      line[SCHED_ARR_TIME] = arr_hr
      line[SCHED_DEP_TIME] = dep_hr
      line.insert(SCHED_ARR_TIME+1,arr_min)
      line.insert(SCHED_DEP_TIME+1,dep_min)
      yield line
    end
  end
end

Wukong::Script.new(
  SplitTimes::Mapper,
  nil
).run
