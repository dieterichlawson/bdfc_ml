#!/usr/bin/env ruby
# encoding:UTF-8

require 'open-uri'
require 'configliere'
require 'set'

NOAA_URL = 'http://www1.ncdc.noaa.gov/pub/data/noaa/isd-lite'
WBANS_FILE = './wbans'

Settings.use :commandline

Settings({
  years: (1987..2012).to_a,
  verbose: false,
  out_dir: "/raw/noaa/isd-lite/",
  un_gzip: false,
})

Settings.define :years, flag: 'y', description: "Years to download",type: Array
Settings.define :station, description: "Station to download", default: ""
Settings.define :verbose, flag: 'v', description: "Get chatty", type: :boolean
Settings.define :un_gzip, flag: 'g', description: "Unzip the files as they are uploaded", type: :boolean
Settings.define :out_dir, flag: 'o', description: "The directory in the hdfs to put the files"

Settings.resolve!

def get_files_for_year(year,wbans)
  year_page = open("#{NOAA_URL}/#{year}")
  years = []
  year_page.each_line do |line|
    next unless line =~ /<a href="[^.]*\.gz">/
    next unless line =~ /#{Settings.station}/
    match = /<a href="([^.]*\.gz)">/.match(line)
    next if match.nil?
    match = match[1]
    years << match if wbans.include? match.split('-')[1].to_i
  end
  return years
end

wbans = Set.new
wban_file = File.open WBANS_FILE
wban_file.each_line do |line|
  wbans.add line.to_i
end
Settings.years.each do |year|
  puts "Downloading files for year #{year}..."
  get_files_for_year(year,wbans).each do |file|
    puts "  Downloading #{file}..."
    $stdout.flush
    remote_path = "#{NOAA_URL}/#{year}/#{file}"
    download_path = "#{Settings[:out_dir]}/#{year}/#{file}"
    `curl -s #{remote_path} | hadoop fs -put - #{download_path}`
  end
end
