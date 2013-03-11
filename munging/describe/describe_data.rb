#!/usr/bin/env ruby

require 'wukong'
require 'set'
require 'json'
require 'configliere'

require_relative '../columns/final_single_city.rb'

Settings.use :commandline
Settings.define :partition_col, :type => Integer, :default => nil

Settings.resolve!

module DescribeData
  class MapperBase < Wukong::Streamer::RecordStreamer
    
    MAPPERS = {}
    
    def mappers_for_columns columns, skip=-1
      columns.collect do |col|
        nil if col.index == skip
        mapper_for_column col
      end
    end

    def mapper_for_column column
      type = MAPPERS[column.type] || MAPPERS[:default]
      type.new(column.index, column.name, column.type)
    end    
  end
  class ReducerBase < Wukong::Streamer::ListReducer
    
    REDUCERS = {}

    def reducer_for_column column
      type = REDUCERS[column.type] || REDUCERS[:default]
      type.new
    end    
  end
  module Basic
    class Mapper < ::DescribeData::MapperBase
      def initialize
        @mappers = mappers_for_columns Columns.columns
      end

      def process *line
        line.each_with_index do |val,index|
          @mappers[index].process val
        end
      end

      def after_stream
        @mappers.each_with_index do |stats,index|
          emit [index, stats.attributes.to_json]
        end
      end
    end
    class Reducer < ::DescribeData::ReducerBase
      def start! *args
        @reducer = reducer_for_column(Columns.columns[key.to_i])
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
  module Partitioned
    class Mapper < ::DescribeData::MapperBase
      def initialize
        @mappers = {}
      end

      def process *line
        @mappers[line[Settings.partition_col]] ||= mappers_for_columns(Columns.columns, Settings.partition_col)
        line.each_with_index do |val,index|
          next if index == Settings.partition_col
          @mappers[line[Settings.partition_col]][index].process val
        end
      end

      def after_stream
        @mappers.each do |partition_key, mappers|
          mappers.each_with_index do |mapper, index|
            next if index == Settings.partition_col
            emit [partition_key, index, mapper.attributes.to_json]
          end
        end
      end
    end
    class Reducer < ::DescribeData::ReducerBase
      def start! *args
        @reducers = {}
      end

      def accumulate key, index, json
        index = index.to_i
        start_reducer(index, json) if @reducers[index].nil?
        @reducers[index].accumulate(JSON.parse(json))
      end

      def start_reducer index, json
        @reducers[index] = reducer_for_column Columns.columns[index]
        @reducers[index].start! JSON.parse(json)
      end

      def finalize
        yield [{ partition_key: key, descriptions: @reducers.collect { |index, reducer| reducer.finalize }}.to_json]
      end
    end
  end
end

require_relative 'column_describers.rb'

if Settings.partition_col.nil?
  $stderr.write "Running basic script\n"
  Wukong::Script.new(
    DescribeData::Basic::Mapper,
    DescribeData::Basic::Reducer
  ).run
else
  $stderr.write "Running partitioned script on: #{Settings.partition_col}\n"
  Wukong::Script.new(
    DescribeData::Partitioned::Mapper,
    DescribeData::Partitioned::Reducer
  ).run
end
