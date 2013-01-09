require_relative '../describe/load_info.rb'

module Munging
  class Normalizer
    include LoadDatasetDescription
  
    def initialize info_path, local
      @data_info = load_desc_by_type info_path, local
      p @data_info
    end

    def normalize example
      @data_info[:number].each do |col|
        index = col[:index]
        val = example[index].to_f
        val = val - col[:mean]
        val = val / col[:std_dev]
        example[index] = val
      end
      example
    end
  end
end
