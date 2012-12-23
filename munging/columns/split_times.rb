require_relative './columns.rb'

module Columns
  module SplitTimes
    extend ColumnBase
    columns ({ 
      year:               :category,
      month:              :category,
      day:                :category,
      day_of_week:        :category,
      origin_airport:     :category,
      dest_airport:       :category,
      sched_dep_hr:       :category,
      sched_dep_min:      :category,
      sched_arr_hr:       :category,
      sched_arr_min:      :category,
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
