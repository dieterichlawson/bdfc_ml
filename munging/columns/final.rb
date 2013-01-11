require_relative './base.rb'

module Columns
  module Final
    extend ColumnBase
    columns ({ 
      dep_year:           :category,
      dep_month:          :category,
      dep_day:            :category,
      dep_dow:            :category,
      dep_hr:             :category,
      orig_airport:       :category,
 
      dest_airport:       :category,     
      
      sched_elapsed_time: :number,
      carrier:            :category,
      distance:           :number,
      prev_arr_delay:     :number,
      
      orig_pressure:      :number,
      orig_wind_speed:    :number,
      orig_sky_cond:      :category,
      orig_precip_hr:     :number,
      orig_precip_sixhr:  :number,

      dest_pressure:      :number,
      dest_wind_speed:    :number,
      dest_sky_cond:      :category,
      dest_precip_hr:     :number,
      dest_precip_sixhr:  :number,

      dep_delay:          :target,
      dep_delay_15:       :target,
      dep_delay_group:    :target,
    }) 
  end
end
