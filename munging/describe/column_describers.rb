require_relative 'column_describers/default_describer.rb'
require_relative 'column_describers/number_describer.rb'
require_relative 'column_describers/category_describer.rb'

describers = ColumnDescribers.constants.select {|c| ColumnDescribers.const_get(c).is_a? Class }

describers.each do |describer|
  if not (describer.to_s =~ /.*Mapper/).nil?
    type = describer.to_s[0..-7].downcase.to_sym
    DescribeData::MapperBase::MAPPERS[type] = ColumnDescribers.const_get describer
  elsif not (describer.to_s =~ /.*Reducer/).nil?
    type = describer.to_s[0..-8].downcase.to_sym
    DescribeData::ReducerBase::REDUCERS[type] = ColumnDescribers.const_get describer
  end
end
