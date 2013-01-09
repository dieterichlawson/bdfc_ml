#!/usr/bin/env ruby

require 'wukong'

module NaiveBayes
  class Mapper < Wukong::Streamer::RecordStreamer
    
    PREDICTOR_COLS = (1..11).to_a
    TARGET = 13

    def process *line
      yield ["class|#{line[TARGET]}"] # count the class num
      line.each_with_index do |value,index|
        next unless PREDICTOR_COLS.include? index
        next if line[TARGET] == ''
        yield ["feature|#{index}|#{value}|#{line[TARGET]}"]
      end
    end
  end
  class Reducer < Wukong::Streamer::AccumulatingReducer

    def start! *args
      @sum = 0
    end
    
    def accumulate *fields
      @sum += 1
    end

    def finalize
      key_parts = key.split '|'
      if key_parts[0] == 'class'
        yield ['class',key_parts[1],@sum]
      elsif key_parts[0] == 'total'
        yield ['total',@sum]
      elsif key_parts[0] == 'feature'
        yield ['feature',key_parts[1],key_parts[2],key_parts[3],@sum]
      end
    end
  end
end

Wukong::Script.new(
  NaiveBayes::Mapper,
  NaiveBayes::Reducer
).run
