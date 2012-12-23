#!/usr/bin/env ruby

require 'wukong'
require 'configliere'

require_relative 'normalizer.rb'

Settings.use :commandline
Settings.define :info_file
Settings.define :local, type: :boolean
Settings.resolve!

module Munging
  class Mapper < Wukong::Streamer::RecordStreamer

    def initialize
      @normalizer = Munging::Normalizer.new Settings.info_file, Settings.local
    end

    def process *line
      yield @normalizer.normalize line
    end
  end
end

Wukong::Script.new(
  Munging::Mapper,
  nil
).run
