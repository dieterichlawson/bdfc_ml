#!/usr/bin/env ruby

require 'net/http'
require 'json'
require 'configliere'

# Ingests the airport table and spits out
# the same table but with dst / raw UTC offsets
# added.
#
# Airport table should be in the format:
# Airport Seq Id, Country Abbreviation, Latitude, Longitude
# with all quotes removed
#
# Output is:
# Aiport Seq Id, GMT offset, DST Offset
#
# WARNING: Geonames API only allows 2k reqs/hr for their
# free accounts, so you will probably hit that limit
# when generating this table.

Settings.use :commandline
Settings.define :in_file, description: "Input airport CSV file", default: "airports_raw.csv"
Settings.define :out_file, description: "File to put output into", default: "airport_offsets.csv"
Settings.define :ignore_header, flag: 'i', description: "Ignore the first line of the file", default: true

Settings.resolve!

AIRPORT_SEQ_ID = 0
COUNTRY = 1
LAT = 2 
LONG = 3 

in_file = open(Settings.in_file)
out_file = File.open(Settings.out_file,'a')

# Increments the number of requests
# made to the geonames API so that you
# can track how close you are to the limit.
def increment_reqs
  @reqs ||= 0
  @reqs += 1
  if @reqs % 100 == 0
    puts "Made #{@reqs} requests"
  end
end

def offset_to_s(offset)
  hrs = offset.to_i
  mins = (offset.to_f - hrs).abs*60
  "#{hrs < 0 ? '-' : '+'}%02d:%02d" % [hrs.abs, mins]
end

def get_offsets(lat,long,airport_id)
  response = Net::HTTP.get_response("api.geonames.org","/timezoneJSON?lat=#{lat}&lng=#{long}&username=okkercat")
  response = JSON.parse(response.body)
  increment_reqs
  # check for errors
  if response.has_key? 'status'
    puts "An API error occurred.\n Message: #{response['status']['message']}\n value: #{response['status']['value']}"
    puts "Lat: #{lat} Long: #{long} airport ID: #{airport_id}"
    return [nil, nil]
  end
  [offset_to_s(response["gmtOffset"]),offset_to_s(response["dstOffset"])]
end

in_file.gets if Settings.ignore_header

# iterate through input file
in_file.each_line do |line|
  line = line.split(',')
  next if line[COUNTRY] != "US"
  gmtOffset, dstOffset = get_offsets(line[LAT],line[LONG],line[AIRPORT_SEQ_ID])
  unless gmtOffset.nil? or dstOffset.nil?
    out_file.puts [line[AIRPORT_SEQ_ID], gmtOffset, dstOffset].join("\t")
    out_file.flush
  end
end

#cleanup
in_file.close
out_file.close
