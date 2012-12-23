#!/usr/bin/env ruby

require 'wukong'
require 'configliere'

require_relative 'discretizer.rb'

Settings.use :commandline
Settings.define :info_file
Settings.define :local, type: :boolean
Settings.resolve!

module Discretize
  class Mapper < Wukong::Streamer::RecordStreamer
  
    def initialize
      @discretizer = Munging::Discretizer.new Settings.info_file, Settings.local
    end

    def process *line
      yield @discretizer.discretize line
    end
  end
end

Wukong::Script.new(
  Discretize::Mapper,
  nil
).run
