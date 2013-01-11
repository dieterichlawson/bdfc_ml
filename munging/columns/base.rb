module ColumnBase

  def included klass
    klass.const_set("COL_NAMES",col_names)
    klass.const_set("COL_TYPES",col_types)
    klass.const_set("COLS_BY_TYPE",cols_by_type)
  end
 
  def columns cols
    cols.each do |name,type|
      col_names << name.to_s
      col_types << type
      cols_by_type[type] ||= []
      cols_by_type[type] << col_names.length - 1
      const_set(name.to_s.upcase,col_names.length-1) 
    end
  end

  def col_names
    @col_names ||= []
  end

  def col_types
    @col_types ||= []
  end

  def cols_by_type
    @cols_by_type ||= {}
  end
end
