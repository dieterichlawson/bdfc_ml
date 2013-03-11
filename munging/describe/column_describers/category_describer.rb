require_relative 'default_describer.rb'
require 'set'

module ColumnDescribers
  class CategoryMapper < DefaultMapper

    def initialize index,name,type
      super index, name, type
      @categories = Set.new
    end

    def process val
      @categories.add val
    end

    def attributes
      super.merge({ categories: @categories.to_a })
    end
  end
  class CategoryReducer < DefaultReducer

    def start! first
      super first
      @categories = Set.new
    end

    def accumulate attrs
      attrs['categories'].map { |cat| @categories.add cat }
    end

    def finalize
      super.merge({num_categories: @categories.size})
    end
  end
end
