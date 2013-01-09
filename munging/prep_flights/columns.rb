# Modules containing column index constants for different stages
# in the transformation process. You should just mix in a module
# wherever you need it.
module Columns 
  module Raw
    COLUMNS = [
      'YEAR','MONTH','DAY','DAY_OF_WEEK','CARRIER',
      'TAIL_NUM','FLIGHT_NUM','ORIGIN_AIRPORT','ORIGIN_FIPS','DEST_AIRPORT',
      'SCHED_DEP_TIME', 'DEP_DELAY','DEP_DELAY_15', 'DEP_DELAY_GROUP', 
      'SCHED_ARR_TIME','ARR_DELAY', 'CANCELLED', 'DIVERTED',
      'SCHED_ELAPSED_TIME','DISTANCE',
    ]
    COLUMNS.each_with_index {|column,index| Raw.const_set(column,index) }
  end
  module Reordered
    COLUMNS = [
      'KEY', 'YEAR','MONTH','DAY','DAY_OF_WEEK',
      'ORIGIN_AIRPORT','ORIGIN_FIPS','DEST_AIRPORT','SCHED_DEP_TIME',
      'SCHED_ARR_TIME','SCHED_ELAPSED_TIME','CARRIER','TAIL_NUM',
      'FLIGHT_NUM','DISTANCE','ARR_DELAY','DEP_DELAY','DEP_DELAY_15',
      'DEP_DELAY_GROUP',
    ]
    COLUMNS.each_with_index {|column,index| Reordered.const_set(column,index) }
  end
  module PrevFlightDelayAdded
    COLUMNS = [
      'YEAR','MONTH','DAY','DAY_OF_WEEK',
      'ORIGIN_AIRPORT','ORIGIN_FIPS','DEST_AIRPORT','SCHED_DEP_TIME',
      'SCHED_ARR_TIME','SCHED_ELAPSED_TIME','CARRIER','DISTANCE',
      'PREV_ARR_DELAY','DEP_DELAY','DEP_DELAY_15','DEP_DELAY_GROUP',
    ]
    COLUMNS.each_with_index {|column,index| PrevFlightDelayAdded.const_set(column,index) }
  end
  module Final
    COLUMNS = [
      'YEAR','MONTH','DAY','DAY_OF_WEEK','ORIGIN_AIRPORT',
      'DEST_AIRPORT','SCHED_DEP_TIME','SCHED_ARR_TIME',
      'SCHED_ELAPSED_TIME','CARRIER','DISTANCE','PREV_ARR_DELAY',
      'DEP_DELAY','DEP_DELAY_15','DEP_DELAY_GROUP',
    ]
    COLUMNS.each_with_index {|column,index| Final.const_set(column,index) }
  end
  module SplitTimes
    COLUMNS = [
      'YEAR','MONTH','DAY','DAY_OF_WEEK','ORIGIN_AIRPORT',
      'DEST_AIRPORT','SCHED_DEP_HR','SCHED_DEP_MIN','SCHED_ARR_HR','SCHED_ARR_MIN',
      'SCHED_ELAPSED_TIME','CARRIER','DISTANCE','PREV_ARR_DELAY',
      'DEP_DELAY','DEP_DELAY_15','DEP_DELAY_GROUP',
    ]
    COLUMNS.each_with_index {|column,index| SplitTimes.const_set(column,index) }
  end
  module Joined
    COLUMNS = [
      'DEP_YEAR','DEP_MONTH','DEP_DAY','DEP_DOW','DEP_HR','DEP_MIN','ORIG_AIRPORT',
      'ARR_YEAR','ARR_MONTH','ARR_DAY','ARR_HR','ARR_MIN','DEST_AIRPORT',
      'SCHED_ELAPSED_TIME','CARRIER','DISTANCE','PREV_ARR_DELAY',
      'ORIG_AIR_TEMP','ORIG_DEW_POINT','ORIG_PRESSURE','ORIG_WIND_DIR',
      'ORIG_WIND_SPEED','ORIG_SKY_COND','ORIG_PRECIP_HR','ORIG_PRECIP_SIXHR',
      'DEST_AIR_TEMP','DEST_DEW_POINT','DEST_PRESSURE','DEST_WIND_DIR',
      'DEST_WIND_SPEED','DEST_SKY_COND','DEST_PRECIP_HR','DEST_PRECIP_SIXHR',
      'DEP_DELAY','DEP_DELAY_15','DEP_DELAY_GROUP',
    ]
    COLUMNS.each_with_index {|column,index| Joined.const_set(column,index) }
  end
  module AfterFilter
    COLUMNS = [
      'DEP_YEAR','DEP_MONTH','DEP_DAY','DEP_DOW','DEP_HR','ORIG_AIRPORT',
      'DEST_AIRPORT',
      'SCHED_ELAPSED_TIME','CARRIER','DISTANCE','PREV_ARR_DELAY',
      'ORIG_PRESSURE',
      'ORIG_WIND_SPEED','ORIG_SKY_COND','ORIG_PRECIP_HR','ORIG_PRECIP_SIXHR',
      'DEST_PRESSURE',
      'DEST_WIND_SPEED','DEST_SKY_COND','DEST_PRECIP_HR','DEST_PRECIP_SIXHR',
      'DEP_DELAY','DEP_DELAY_15','DEP_DELAY_GROUP',
    ]
    COLUMNS.each_with_index {|column,index| AfterFilter.const_set(column,index) }
  end
  module SingleCity
    COLUMNS = [
      'DEP_YEAR','DEP_MONTH','DEP_DAY','DEP_DOW','DEP_HR',
      'DEST_AIRPORT',
      'SCHED_ELAPSED_TIME','CARRIER','DISTANCE','PREV_ARR_DELAY',
      'ORIG_PRESSURE',
      'ORIG_WIND_SPEED','ORIG_SKY_COND','ORIG_PRECIP_HR','ORIG_PRECIP_SIXHR',
      'DEST_PRESSURE',
      'DEST_WIND_SPEED','DEST_SKY_COND','DEST_PRECIP_HR','DEST_PRECIP_SIXHR',
      'DEP_DELAY','DEP_DELAY_15','DEP_DELAY_GROUP',
    ]
    COLUMNS.each_with_index {|column,index| SingleCity.const_set(column,index) }
  end
end
