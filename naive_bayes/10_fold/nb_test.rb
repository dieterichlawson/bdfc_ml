#!/usr/bin/env ruby

require 'wukong'
require 'wukong/streamer/counting_reducer'
require 'configliere'
load '/home/dlaw/nb/10_fold/nb_classifier.rb'
load '/home/dlaw/delay/scripts/columns.rb'

Settings.use :commandline
Settings.define :leave_out, default: 9
Settings.define :model_dir
Settings.resolve!

module NaiveBayesTest
  class Mapper < Wukong::Streamer::RecordStreamer
    include Columns::SingleCity

    MODEL_DIR = "/home/dlaw/models/#{Settings.model_dir}"
    PREDICTOR_COLS = (DEP_YEAR..DEST_PRECIP_SIXHR).to_a
    TARGET = DEP_DELAY_15

    def initialize
      models = (1..10).to_a
      models.delete Settings.leave_out
      @model = NaiveBayes::Classifier.new PREDICTOR_COLS
      models.each do |num|
        @model.add_model "#{MODEL_DIR}/model_#{num}"
      end
    end

    def process *line
      prediction = @model.classify line
      if prediction == line[TARGET]
        yield ['right']
        yield ["right #{line[TARGET]}"]
      else
        yield ['wrong']
        yield ["wrong #{line[TARGET]}"]
      end
    end
  end
  class Reducer < Wukong::Streamer::CountingReducer
  end
end

Wukong::Script.new(
  NaiveBayesTest::Mapper,
  NaiveBayesTest::Reducer
).run
