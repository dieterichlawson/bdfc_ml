require_relative './columns.rb'

module Columns
  module Raw
    extend ColumnBase
    columns ({ 
      year:               :category,
      month:              :category,
      day:                :category,
      day_of_week:        :category,
      carrier:            :category,
      tail_num:           :category,
      flight_num:         :category,
      origin_airport:     :category,
      origin_fips:        :category,
      dest_airport:       :category,
      sched_dep_time:     :time,
      dep_delay:          :target,
      dep_delay_15:       :target,
      dep_delay_group:    :target,
      sched_arr_time:     :time,
      arr_delay:          :number,
      cancelled:          :category,
      diverted:           :category,
      sched_elapsed_time: :time,
      distance:           :number,
    }) 
  end
end
