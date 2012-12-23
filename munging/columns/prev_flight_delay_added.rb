require_relative './columns.rb'

module Columns
  module PrevFlightDelayAdded
    extend ColumnBase
    columns ({ 
      year:               :category,
      month:              :category,
      day:                :category,
      day_of_week:        :category,
      origin_airport:     :category,
      origin_fips:        :category,
      dest_airport:       :category,
      sched_dep_time:     :time,
      sched_arr_time:     :time,
      sched_elapsed_time: :number,
      carrier:            :category,
      distance:           :number,
      prev_arr_delay:     :number,
      dep_delay:          :target,
      dep_delay_15:       :target,
      dep_delay_group:    :target,
    }) 
  end
end
