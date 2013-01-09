#!/usr/bin/env ruby

require 'wukong'
require 'set'
require 'json'

require_relative '../columns/final_single_city.rb'
require_relative 'column_describers.rb'

module DescribeData
  class Mapper < Wukong::Streamer::RecordStreamer
    include Columns::FinalSingleCity 
    
    MAPPERS = {
      category: ColumnDescriber::CategoricalMapper,
      number: ColumnDescriber::NumericMapper,
      default: ColumnDescriber::DefaultMapper,
    }

    def initialize
      @col_stats = []
      COL_TYPES.each_with_index do |type,index|
        if MAPPERS.include? type
          @col_stats << MAPPERS[type].new(index, COL_NAMES[index], type)
        else
          @col_stats << MAPPERS[:default].new(index, COL_NAMES[index], type)
        end
      end
    end

    def process *line
      line.each_with_index do |val,index|
        @col_stats[index].process val
      end
    end

    def after_stream
      @col_stats.each_with_index do |stats,index|
        emit [index,stats.attributes.to_json]
      end
    end
  end
  class Reducer < Wukong::Streamer::ListReducer
    include Columns::FinalSingleCity

    REDUCERS = {
      category: ColumnDescriber::CategoricalReducer,
      number: ColumnDescriber::NumericReducer,
      default: ColumnDescriber::DefaultReducer,
    }
    
    def start! *args
      type = COL_TYPES[key.to_i]
      if REDUCERS.include? type
        @reducer = REDUCERS[type].new
      else
        @reducer = REDUCERS[:default].new
      end
      @reducer.start! JSON.parse args[1]
    end

    def accumulate *fields
      @reducer.accumulate JSON.parse fields[1]
    end

    def finalize 
      yield [@reducer.finalize.to_json]
    end
  end
end

Wukong::Script.new(
  DescribeData::Mapper,
  DescribeData::Reducer
).run
