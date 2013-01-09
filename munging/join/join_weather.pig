%default WEATHER_DATA '/data/noaa/with_seqid'
%default FLIGHT_DATA  '/data/bts/incl_arr_date'
%default JOINED_OUT   '/data/bts_noaa'

weather = LOAD '$WEATHER_DATA' AS 
(seq_id:int, wban:chararray, year:int, month:int, day:int, hour:int,
 air_temp:chararray,dew_point:chararray,pressure:chararray,wind_dir:chararray,
 wind_speed:chararray,sky_cond:chararray,precip_hr:chararray,precip_sixhr);

flights = LOAD '$FLIGHT_DATA' AS
(year:int, month:int, day:int, dow:int, origin_seq_id:int, dest_seq_id:int,
 sched_dep_hr:int, sched_dep_min:int, arr_year:int, arr_month:int, arr_day:int,
 sched_arr_hr:int, sched_arr_min:int, sched_elapsed_time:chararray, 
 carrier:chararray, distance:chararray, prev_arr_delay:chararray, 
 dep_delay:chararray, dep_delay_ind:chararray, dep_delay_grp:chararray);

first_join = JOIN flights BY (origin_seq_id, year, month, day, sched_dep_hr), weather BY (seq_id,year,month,day,hour);
with_origin = FOREACH first_join GENERATE
 flights::year AS year, flights::month AS month, flights::day AS day, flights::dow AS dow, 
 flights::origin_seq_id AS orig_seq_id, flights::dest_seq_id AS dest_seq_id,
 flights::sched_dep_hr AS sched_dep_hr, flights::sched_dep_min AS sched_dep_min, 
 flights::arr_year AS arr_year, flights::arr_month AS arr_month, flights::arr_day AS arr_day,
 flights::sched_arr_hr AS sched_arr_hr, flights::sched_arr_min AS sched_arr_min, 
 flights::sched_elapsed_time AS sched_elapsed_time, flights::carrier AS carrier, 
 flights::distance AS distance, flights::prev_arr_delay AS prev_arr_delay,
 weather::air_temp AS o_air_temp, weather::dew_point AS o_dew_point,
 weather::pressure AS o_pressure, weather::wind_dir AS o_wind_dir,
 weather::wind_speed AS o_wind_speed, weather::sky_cond AS o_sky_cond,
 weather::precip_hr AS o_precip_hr, weather::precip_sixhr AS o_precip_sixhr,
 flights::dep_delay AS dep_delay, flights::dep_delay_ind AS dep_delay_ind, 
 flights::dep_delay_grp AS dep_delay_grp;

second_join = JOIN with_origin BY (dest_seq_id, arr_year, arr_month, arr_day, sched_arr_hr), weather BY (seq_id,year,month,day,hour);
final = FOREACH second_join GENERATE
 with_origin::year AS dep_year, with_origin::month AS dep_month, with_origin::day AS dep_day, with_origin::dow AS dep_dow,
 with_origin::sched_dep_hr AS sched_dep_hr, with_origin::sched_dep_min AS sched_dep_min, 
 with_origin::orig_seq_id AS orig_seq_id, 

 with_origin::arr_year AS arr_year, with_origin::arr_month AS arr_month, with_origin::arr_day AS arr_day, 
 with_origin::sched_arr_hr AS sched_arr_hr, with_origin::sched_arr_min AS sched_arr_min, 
 with_origin::dest_seq_id AS dest_seq_id,

 with_origin::sched_elapsed_time AS sched_elapsed_time, with_origin::carrier AS carrier, 
 with_origin::distance AS distance, with_origin::prev_arr_delay AS prev_arr_delay,

 with_origin::o_air_temp AS o_air_temp, with_origin::o_dew_point AS o_dew_point,
 with_origin::o_pressure AS o_pressure, with_origin::o_wind_dir AS o_wind_dir,
 with_origin::o_wind_speed AS o_wind_speed, with_origin::o_sky_cond AS o_sky_cond,
 with_origin::o_precip_hr AS o_precip_hr, with_origin::o_precip_sixhr AS o_precip_sixhr,
 
 weather::air_temp AS d_air_temp, weather::dew_point AS d_dew_point,
 weather::pressure AS d_pressure, weather::wind_dir AS d_wind_dir,
 weather::wind_speed AS d_wind_speed, weather::sky_cond AS d_sky_cond,
 weather::precip_hr AS d_precip_hr, weather::precip_sixhr AS d_precip_sixhr,
 
 with_origin::dep_delay AS dep_delay, with_origin::dep_delay_ind AS dep_delay_ind, 
 with_origin::dep_delay_grp AS dep_delay_grp;

STORE final INTO '$JOINED_OUT';
