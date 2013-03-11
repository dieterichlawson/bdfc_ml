require_relative './base.rb'

Columns.define do
  category 'dep_year'
  category 'dep_month'
  category 'dep_day'
  category 'dep_dow'
  category 'dep_hr'

  category 'dest_airport'

  number   'sched_elapsed_time'
  category 'carrier'
  number   'distance'
  number   'prev_arr_delay'

  number   'orig_pressure'
  number   'orig_wind_speed'
  category 'orig_sky_cond'
  number   'orig_precip_hr'
  number   'orig_precip_sixhr'

  number   'dest_pressure'
  number   'dest_wind_speed'
  category 'dest_sky_cond'
  number   'dest_precip_hr'
  number   'dest_precip_sixhr'

  target   'dep_delay'
  target   'dep_delay_15'
  target   'dep_delay_group'
end
