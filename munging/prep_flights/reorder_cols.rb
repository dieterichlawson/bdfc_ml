#!/usr/bin/env ruby

$:.unshift "/home/dlaw/dev/wukong_og/lib"
$:.unshift "/home/dlaw/dev/gorillib/lib"

load "/home/dlaw/delay/scripts/columns.rb"

require 'wukong'
require 'wukong/streamer/encoding_cleaner'
require 'date'

module ColumnReorderer
  class Mapper < Wukong::Streamer::RecordStreamer
    include Wukong::Streamer::EncodingCleaner
    include Columns::Raw

    def process *line
      #remove cancelled and diverted flights
      return if line[CANCELLED].to_i == 1 or line[DIVERTED].to_i == 1
      result = []
      # reorder the columns
      result << line[YEAR..DAY_OF_WEEK]
      result << line[ORIGIN_AIRPORT..ORIGIN_FIPS] 
      result << line[DEST_AIRPORT]
      result << line[SCHED_DEP_TIME]
      result << line[SCHED_ARR_TIME] 
      result << line[SCHED_ELAPSED_TIME] 
      result << line[CARRIER..FLIGHT_NUM] 
      result << line[DISTANCE] 
      result << line[ARR_DELAY] 
      result << line[DEP_DELAY..DEP_DELAY_GROUP]
      yield ["#{line[YEAR]}-#{line[MONTH]}-#{line[DAY]}-#{line[TAIL_NUM]}",result.flatten]
    end
  end
  class Reducer < Wukong::Streamer::ListReducer
    include Columns::Reordered

    # Add previous flight delays
    def finalize
      values.sort! {|x,y| x[SCHED_DEP_TIME].to_i <=> y[SCHED_DEP_TIME].to_i }
      prev_dest = ''
      prev_arr_delay = 0.00
      values.each_with_index do |flight,index|
        if prev_dest == flight[ORIGIN_AIRPORT]
          flight.insert(ARR_DELAY+1,prev_arr_delay)
        else
          flight.insert(ARR_DELAY+1,"0.00")
        end
        prev_dest = flight[DEST_AIRPORT]
        prev_arr_delay = flight[ARR_DELAY]
        [ARR_DELAY, FLIGHT_NUM, TAIL_NUM, KEY].each { |index| flight.delete_at(index)}
        yield flight
      end
    end
  end
end

Wukong::Script.new(
  ColumnReorderer::Mapper,
  ColumnReorderer::Reducer
).run
