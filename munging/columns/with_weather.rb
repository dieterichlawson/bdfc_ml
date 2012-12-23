require_relative './columns.rb'

module Columns
  module WithWeather
    extend ColumnBase
    columns ({ 
      dep_year:           :category,
      dep_month:          :category,
      dep_day:            :category,
      dep_dow:            :category,
      dep_hr:             :category,
      dep_min:            :category,
      orig_airport:       :category,
 
      arr_year:           :category,
      arr_month:          :category,
      arr_day:            :category,
      arr_dow:            :category,
      arr_hr:             :category,
      arr_min:            :category,
      dest_airport:       :category,     
      
      sched_elapsed_time: :number,
      carrier:            :category,
      distance:           :number,
      prev_arr_delay:     :number,
      
      orig_air_temp:      :number,
      orig_dew_point:     :number,
      orig_pressure:      :number,
      orig_wind_dir:      :direction_degrees,
      orig_wind_speed:    :number,
      orig_sky_cond:      :category,
      orig_precip_hr:     :number,
      orig_precip_sixhr:  :number,

      dest_air_temp:      :number,
      dest_dew_point:     :number,
      dest_pressure:      :number,
      dest_wind_dir:      :direction_degrees,
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
