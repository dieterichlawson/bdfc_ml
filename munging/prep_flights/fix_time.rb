#!/usr/bin/env ruby

require 'wukong'
require 'date'
load '/home/dlaw/delay/scripts/columns.rb'

# Wukong script to transform all local times to UTC
module FixTime
  class Mapper < Wukong::Streamer::RecordStreamer
    include Columns::PrevFlightDelayAdded
   
    # File containing airport_id => DST and GMT offset mapping
    OFFSET_TABLE_FILE = '/home/dlaw/delay/scripts/airport_offset/airport_offsets.csv'

    # DST start and stop dates for the USA
    DST_RULES = {
      1987 => [Date.parse("1987-04-05"), Date.parse("1987-10-25")],
      1988 => [Date.parse("1988-04-03"), Date.parse("1988-10-30")],
      1989 => [Date.parse("1989-04-02"), Date.parse("1989-10-29")],
      1990 => [Date.parse("1990-04-01"), Date.parse("1990-10-28")],
      1991 => [Date.parse("1991-04-07"), Date.parse("1991-10-27")],
      1992 => [Date.parse("1992-04-05"), Date.parse("1992-10-25")],
      1993 => [Date.parse("1993-04-04"), Date.parse("1993-10-31")],
      1994 => [Date.parse("1994-04-03"), Date.parse("1994-10-30")],
      1995 => [Date.parse("1995-04-02"), Date.parse("1995-10-29")],
      1996 => [Date.parse("1996-04-07"), Date.parse("1996-10-27")],
      1997 => [Date.parse("1997-04-06"), Date.parse("1997-10-26")],
      1998 => [Date.parse("1998-04-05"), Date.parse("1998-10-25")],
      1999 => [Date.parse("1999-04-04"), Date.parse("1999-10-31")],
      2000 => [Date.parse("2000-04-02"), Date.parse("2000-10-29")],
      2001 => [Date.parse("2001-04-01"), Date.parse("2001-10-28")],
      2002 => [Date.parse("2002-04-07"), Date.parse("2002-10-27")],
      2003 => [Date.parse("2003-04-06"), Date.parse("2003-10-26")],
      2004 => [Date.parse("2004-04-04"), Date.parse("2004-10-31")],
      2005 => [Date.parse("2005-04-03"), Date.parse("2005-10-30")],
      2006 => [Date.parse("2006-04-02"), Date.parse("2006-10-29")],
      2007 => [Date.parse("2007-03-11"), Date.parse("2007-11-04")],
      2008 => [Date.parse("2008-03-09"), Date.parse("2008-11-02")],
      2009 => [Date.parse("2009-03-08"), Date.parse("2009-11-01")],
      2010 => [Date.parse("2010-03-14"), Date.parse("2010-11-07")],
      2011 => [Date.parse("2011-03-13"), Date.parse("2011-11-06")],
      2012 => [Date.parse("2012-03-11"), Date.parse("2012-11-04")],
    }

    #AZ, HI, Virgin Islands, Puerto Rice, Wake Island, America Somoa, Midway Islands, Guam have no DST
    NON_DST_FIPS = [4,15,60,72,78,79,71,66] 

    # load the offset table into memory
    def initialize
      @offsets = {}
      File.open(OFFSET_TABLE_FILE,'r') do |file|
        file.each_line do |line|
          line = line[0..-2]
          line = line.split("\t")
          @offsets[line[0][0..-3].to_i] = [line[1],line[2]]
        end
      end
    end

    def is_dst?(date,time,fips)
      return false if NON_DST_FIPS.include? fips.to_i
      year = date.split('-')[0].to_i
      date = Date.parse(date)
      if date > DST_RULES[year].first and date < DST_RULES[year].last
        return true
      elsif date < DST_RULES[year].first or date > DST_RULES[year].last
        return false
      elsif date == DST_RULES[year].first
        return time.to_i >= 300 # Spring forward from 2:00 to 3:00
      elsif date == DST_RULES[year].last
        return time.to_i <= 100 # Arbitrarily say that the lost hour is outside DST
      end
    end

    # Returns a ruby time object for the given time and location
    def get_time(airport_id, fips, year, month, day, time)
      date = "#{year}-#{month}-#{day}"
      offset = @offsets[airport_id][is_dst?(date,time,fips) ? 1:0]
      hrs = time[0..1].to_i
      mins = time[2..3].to_i
      Time.new(year.to_i,month.to_i,day.to_i,hrs,mins,0,offset)
    rescue StandardError => e
      $stderr.write "Error during get_time: '#{e}'\n"
      $stderr.write "params: airport_id:'#{airport_id}' fips:'#{fips}' date:'#{year}-#{month}-#{day}' time: '#{time}'\n"
      $stderr.write "offset: '#{@offsets[airport_id]}'\n"
      return nil
    end

    # Returns a tuple of departure time and arrival time for the given line
    def get_times(line)
      orig_time = get_time(line[ORIGIN_AIRPORT].to_i,line[ORIGIN_FIPS],
                           line[YEAR].to_i,line[MONTH].to_i,
                           line[DAY].to_i,line[SCHED_DEP_TIME])
      # add the elapsed time to get scheduled destination time
      dest_time = orig_time + line[SCHED_ELAPSED_TIME].to_i * 60 
      [orig_time, dest_time]
    end

    def process *line
      return if line[ORIGIN_AIRPORT] == '15994'
      orig_time, dest_time = get_times(line)
      orig_time.utc
      dest_time.utc
      line[YEAR] = orig_time.year
      line[MONTH] = orig_time.month
      line[DAY] = orig_time.day
      line[DAY_OF_WEEK] = orig_time.wday
      line[SCHED_DEP_TIME] = orig_time.strftime("%H%M")
      line[SCHED_ARR_TIME] = dest_time.strftime("%H%M")
      # Don't need the FIPS code anymore
      line.delete_at ORIGIN_FIPS
      yield line
    rescue StandardError => e
      $stderr.write "Error during process: '#{e}'\n"
      $stderr.write "Line: '#{line}'\n"
      yield line[ORIGIN_AIRPORT]
    end
  end
end

Wukong::Script.new(
  FixTime::Mapper,
  nil
).run
