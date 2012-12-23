module Munging
  class RowGenerator

    def initialize column_types
      @column_types = column_types
      @categories = {}
      @column_types.each_with_index do |type,index|
        next unless type == :category
        num_categories = Random.rand(10..24)
        @categories[index] = []
        (1..num_categories).each do
          category = (1..3).map { ('A'..'Z').to_a[rand(26)] }.join
          unless @categories[index].include? category
            @categories[index] << category
          end
        end
      end
    end
  
    def get_row
      row = []
      @column_types.each_with_index do |type,index|
        if type == :number
          row << get_float
        elsif type == :category
          row << get_category(index)
        elsif type == :time
          row << get_time
        elsif type == :direction_degrees
          row << get_direction
        elsif type == :target
          row << get_target
        end
      end
      row.join "\t"
    end

    def get_float
      Random.rand * 100.0
    end

    def get_category index
      @categories[index][Random.rand(@categories[index].length)]
    end

    def get_target
      'Target'
    end

    def get_direction
      Random.rand(360)
    end

    def get_time
      "#{Random.rand(24)}#{Random.rand(60)}"
    end
  end
end
