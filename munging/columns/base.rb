module Columns
  def self.define &blk
    module_eval &blk
  end

  def self.columns
    @@columns ||= []
  end

  def self.num_columns
    columns.size
  end

  def self.names
    columns.collect{ |c| c.name }
  end

  def self.for_name name
    columns.select{ |c| c.name == name }[0]
  end

  def self.types
    columns.collect{ |c| c.type }
  end

  def self.define_column name, type, missing_vals=nil
    columns << Column.new(name, type, num_columns, missing_vals)
  end

  def self.method_missing(method, *args, &block)
    define_column args[0], method.to_sym, args[1]
  end

  class Column
    attr_accessor :name, :type, :index, :missing_vals
    def initialize name, type, index, missing_vals=nil
      @name = name
      @type = type
      @index = index
      @missing_vals = missing_vals
    end
  end
end
