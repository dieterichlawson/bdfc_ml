#!/usr/bin/env ruby

load 'rowgen.rb'
require_relative '../../columns/final_single_city.rb'

include Columns::FinalSingleCity

rowgen = Munging::RowGenerator.new COL_TYPES

(1..10).each do
  puts rowgen.get_row
end

