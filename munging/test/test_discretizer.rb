#!/usr/bin/env ruby

require_relative '../columns/only_usa.rb'
require_relative 'rowgen.rb'
require_relative 'discretizer.rb'

include Columns::OnlyUSA

d = Munging::Discretizer.new 'ranges', COL_TYPES
r = Munging::RowGenerator.new COL_TYPES

(1..100).each do |number|
  row = r.get_row
  row = row.split "\t"
  disc = d.discretize row
  puts "#{row} -> #{disc}"
end
