module ColumnDescribers
  class DefaultMapper
  
    def initialize index,name,type
      @index = index
      @name = name
      @type = type
    end

    def process val
    end

    def attributes
      {
        name: @name,
        index: @index,
        type: @type,
      }
    end
  end
  class DefaultReducer

    def start! first
      @name = first['name']
      @type = first['type']
      @index = first['index']
    end

    def accumulate fields
    end

    def finalize
      { 
        name: @name,
        type: @type,
        index: @index
      }
    end
  end
end
