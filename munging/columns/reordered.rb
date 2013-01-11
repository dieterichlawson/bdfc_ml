require_relative './base.rb'

module Columns
  module Reordered
    extend ColumnBase
    columns ({ 
      key:                :category,
      year:               :category,
      month:              :category,
      day:                :category,
      day_of_week:        :category,
      origin_airport:     :category,
      origin_fips:        :category,
      dest_airport:       :category,
      sched_dep_time:     :time,
      sched_arr_time:     :time,
      sched_elapsed_time: :time,
      carrier:            :category,
      tail_num:           :category,
      flight_num:         :category,
      distance:           :number,
      arr_delay:          :number,
      dep_delay:          :target,
      dep_delay_15:       :target,
      dep_delay_group:    :target,
    }) 
  end
end
