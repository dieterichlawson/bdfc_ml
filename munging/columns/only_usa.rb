require_relative './base.rb'

Columns.define do
  category 'year'
  category 'month'
  category 'day'
  category 'day_of_week'
  category 'origin_airport'
  category 'dest_airport'
  time     'sched_dep_time'
  time     'sched_arr_time'
  number   'sched_elapsed_time'
  category 'carrier'
  number   'distance'
  number   'prev_arr_delay'
  target   'dep_delay'
  target   'dep_delay_15'
  target   'dep_delay_group'
end
