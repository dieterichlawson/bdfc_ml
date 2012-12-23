require 'set'
require_relative '../describe/load_info.rb'

module Munging
  class Discretizer
    include LoadDatasetDescription

    # number of categories to split
    # the different data types into
    NUM_CATEGORIES = {
      number: 10,
      direction_degrees: 8,
      time: 24,
    }

    MISSING_VALUES = [-999.0,-9999.0]

    def initialize info_file_path , local
      col_info = load_desc_by_type info_file_path, local
      @categories = {}
      NUM_CATEGORIES.keys.each do |type|
        next unless col_info.include? type
        col_info[type].each do |col|
          feature = col['index']
          min = col['min']
          max = col['max']
          range = max - min
          width = range / NUM_CATEGORIES[type]
          boundaries = []
          (0..NUM_CATEGORIES[type]).each do |index|
            boundaries << min + index*width
          end
          @categories[feature] = boundaries
        end
      end
      @relevant_cols = Set.new @categories.keys
    end

    def discretize example
      disc = example.dup
      disc.each_with_index do |val, index|  
        disc[index] = discretize_col(index, val.to_f) if @relevant_cols.include? index
      end
      disc
    end

    def discretize_col col_num, val
      return val if MISSING_VALUES.include? val
      index = 0
      while @categories[col_num].length > index and @categories[col_num][index] < val
        index += 1
      end
      index
    end
  end
end
