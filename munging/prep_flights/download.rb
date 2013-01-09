#!/usr/bin/env ruby
require 'configliere'

Settings.use :commandline

Settings.define :year, flag: 'y', description: 'Retrieve this year', type: Integer, default: nil
Settings.define :month, flag: 'm', description: "Retrieve only this month", default: nil
Settings.define :out_dir, flag: 'o', description: "Place files in this directory", default: File.dirname(__FILE__)
Settings.define :unzip, flag: 'u', description: "Extract the files and remove the original zip files", default: true
Settings.define :to_tsv, flag: 't', description: "Transform the file to TSV", default: false
Settings.define :remove_header, flag: 'r', description: "Remove the header on the first line", default: false
Settings.define :concatenate, flag: 'c', description: "Concatenate multiple months into one file", default: false
Settings.define :hdp_put, flag: 'h', description: "Put the files on the hdfs. Automatically enforces the concatenate option.", default: false
Settings.define :hfs_out, description: "Directory in which to put the files on the hdfs", default: '/data/raw'
Settings.define :production, flag: 'p', description: "Used production defaults (to tsv, remove header, concatenate years)", default: false
Settings.resolve!

MONTHS =  %q{January February March April May June July August September October November December}.split
YEARS = (1987..2012)

def get_post_params(year,month,month_num)
  "UserTableName=On_Time_Performance&DBShortName=On_Time&RawDataTable=T_ONTIME&sqlstr=+SELECT+YEAR%2CMONTH%2CDAY_OF_MONTH%2CDAY_OF_WEEK%2CUNIQUE_CARRIER%2CTAIL_NUM%2CFL_NUM%2CORIGIN_AIRPORT_ID%2CORIGIN_STATE_FIPS%2CDEST_AIRPORT_ID%2CCRS_DEP_TIME%2CDEP_DELAY_NEW%2CDEP_DEL15%2CDEP_DELAY_GROUP%2CCRS_ARR_TIME%2CARR_DELAY%2CCANCELLED%2CDIVERTED%2CCRS_ELAPSED_TIME%2CDISTANCE+FROM++T_ONTIME+WHERE+Month+%3D#{month_num}+AND+YEAR%3D#{year}&varlist=YEAR%2CMONTH%2CDAY_OF_MONTH%2CDAY_OF_WEEK%2CUNIQUE_CARRIER%2CTAIL_NUM%2CFL_NUM%2CORIGIN_AIRPORT_ID%2CORIGIN_STATE_FIPS%2CDEST_AIRPORT_ID%2CCRS_DEP_TIME%2CDEP_DELAY_NEW%2CDEP_DEL15%2CDEP_DELAY_GROUP%2CCRS_ARR_TIME%2CARR_DELAY%2CCANCELLED%2CDIVERTED%2CCRS_ELAPSED_TIME%2CDISTANCE&grouplist=&suml=&sumRegion=&filter1=title%3D&filter2=title%3D&geo=All%A0&time=#{month}&timename=Month&GEOGRAPHY=All&XYEAR=#{year}&FREQUENCY=1&VarName=YEAR&VarDesc=Year&VarType=Num&VarDesc=Quarter&VarType=Num&VarName=MONTH&VarDesc=Month&VarType=Num&VarName=DAY_OF_MONTH&VarDesc=DayofMonth&VarType=Num&VarName=DAY_OF_WEEK&VarDesc=DayOfWeek&VarType=Num&VarDesc=FlightDate&VarType=Char&VarName=UNIQUE_CARRIER&VarDesc=UniqueCarrier&VarType=Char&VarDesc=AirlineID&VarType=Num&VarDesc=Carrier&VarType=Char&VarName=TAIL_NUM&VarDesc=TailNum&VarType=Char&VarName=FL_NUM&VarDesc=FlightNum&VarType=Char&VarName=ORIGIN_AIRPORT_ID&VarDesc=OriginAirportID&VarType=Num&VarDesc=OriginAirportSeqID&VarType=Num&VarDesc=OriginCityMarketID&VarType=Num&VarDesc=Origin&VarType=Char&VarDesc=OriginCityName&VarType=Char&VarDesc=OriginState&VarType=Char&VarName=ORIGIN_STATE_FIPS&VarDesc=OriginStateFips&VarType=Char&VarDesc=OriginStateName&VarType=Char&VarDesc=OriginWac&VarType=Num&VarName=DEST_AIRPORT_ID&VarDesc=DestAirportID&VarType=Num&VarDesc=DestAirportSeqID&VarType=Num&VarDesc=DestCityMarketID&VarType=Num&VarDesc=Dest&VarType=Char&VarDesc=DestCityName&VarType=Char&VarDesc=DestState&VarType=Char&VarDesc=DestStateFips&VarType=Char&VarDesc=DestStateName&VarType=Char&VarDesc=DestWac&VarType=Num&VarName=CRS_DEP_TIME&VarDesc=CRSDepTime&VarType=Char&VarDesc=DepTime&VarType=Char&VarDesc=DepDelay&VarType=Num&VarName=DEP_DELAY_NEW&VarDesc=DepDelayMinutes&VarType=Num&VarName=DEP_DEL15&VarDesc=DepDel15&VarType=Num&VarName=DEP_DELAY_GROUP&VarDesc=DepartureDelayGroups&VarType=Num&VarDesc=DepTimeBlk&VarType=Char&VarDesc=TaxiOut&VarType=Num&VarDesc=WheelsOff&VarType=Char&VarDesc=WheelsOn&VarType=Char&VarDesc=TaxiIn&VarType=Num&VarName=CRS_ARR_TIME&VarDesc=CRSArrTime&VarType=Char&VarDesc=ArrTime&VarType=Char&VarName=ARR_DELAY&VarDesc=ArrDelay&VarType=Num&VarDesc=ArrDelayMinutes&VarType=Num&VarDesc=ArrDel15&VarType=Num&VarDesc=ArrivalDelayGroups&VarType=Num&VarDesc=ArrTimeBlk&VarType=Char&VarName=CANCELLED&VarDesc=Cancelled&VarType=Num&VarDesc=CancellationCode&VarType=Char&VarName=DIVERTED&VarDesc=Diverted&VarType=Num&VarName=CRS_ELAPSED_TIME&VarDesc=CRSElapsedTime&VarType=Num&VarDesc=ActualElapsedTime&VarType=Num&VarDesc=AirTime&VarType=Num&VarDesc=Flights&VarType=Num&VarName=DISTANCE&VarDesc=Distance&VarType=Num&VarDesc=DistanceGroup&VarType=Num&VarDesc=CarrierDelay&VarType=Num&VarDesc=WeatherDelay&VarType=Num&VarDesc=NASDelay&VarType=Num&VarDesc=SecurityDelay&VarType=Num&VarDesc=LateAircraftDelay&VarType=Num&VarDesc=FirstDepTime&VarType=Char&VarDesc=TotalAddGTime&VarType=Num&VarDesc=LongestAddGTime&VarType=Num&VarDesc=DivAirportLandings&VarType=Num&VarDesc=DivReachedDest&VarType=Num&VarDesc=DivActualElapsedTime&VarType=Num&VarDesc=DivArrDelay&VarType=Num&VarDesc=DivDistance&VarType=Num&VarDesc=Div1Airport&VarType=Char&VarDesc=Div1AirportID&VarType=Num&VarDesc=Div1AirportSeqID&VarType=Num&VarDesc=Div1WheelsOn&VarType=Char&VarDesc=Div1TotalGTime&VarType=Num&VarDesc=Div1LongestGTime&VarType=Num&VarDesc=Div1WheelsOff&VarType=Char&VarDesc=Div1TailNum&VarType=Char&VarDesc=Div2Airport&VarType=Char&VarDesc=Div2AirportID&VarType=Num&VarDesc=Div2AirportSeqID&VarType=Num&VarDesc=Div2WheelsOn&VarType=Char&VarDesc=Div2TotalGTime&VarType=Num&VarDesc=Div2LongestGTime&VarType=Num&VarDesc=Div2WheelsOff&VarType=Char&VarDesc=Div2TailNum&VarType=Char&VarDesc=Div3Airport&VarType=Char&VarDesc=Div3AirportID&VarType=Num&VarDesc=Div3AirportSeqID&VarType=Num&VarDesc=Div3WheelsOn&VarType=Char&VarDesc=Div3TotalGTime&VarType=Num&VarDesc=Div3LongestGTime&VarType=Num&VarDesc=Div3WheelsOff&VarType=Char&VarDesc=Div3TailNum&VarType=Char&VarDesc=Div4Airport&VarType=Char&VarDesc=Div4AirportID&VarType=Num&VarDesc=Div4AirportSeqID&VarType=Num&VarDesc=Div4WheelsOn&VarType=Char&VarDesc=Div4TotalGTime&VarType=Num&VarDesc=Div4LongestGTime&VarType=Num&VarDesc=Div4WheelsOff&VarType=Char&VarDesc=Div4TailNum&VarType=Char&VarDesc=Div5Airport&VarType=Char&VarDesc=Div5AirportID&VarType=Num&VarDesc=Div5AirportSeqID&VarType=Num&VarDesc=Div5WheelsOn&VarType=Char&VarDesc=Div5TotalGTime&VarType=Num&VarDesc=Div5LongestGTime&VarType=Num&VarDesc=Div5WheelsOff&VarType=Char&VarDesc=Div5TailNum&VarType=Char"
end

def download(year,month,out_dir)
  puts "Downloading #{month} #{year}"
  `curl -L -d "#{get_post_params(year,month,MONTHS.index(month)+1)}" 'http://www.transtats.bts.gov/DownLoad_Table.asp?Table_ID=236&Has_Group=3&Is_Zipped=0' > #{out_dir}/#{month}-#{year}.zip`
end

def unzip(year, month, out_dir)
  puts "Unzipping #{month} #{year}"
  `unzip -p #{out_dir}/#{month}-#{year}.zip > #{out_dir}/#{month}-#{year}.csv`
  `rm #{out_dir}/#{month}-#{year}.zip`
end

def transform(filename)
   `sed -i 's/"//g' #{filename}`  #remove quotes
   `sed -i 's/,$//g' #{filename}`  #remove trailing commas
   `sed -i '1d' #{filename}` if Settings.remove_header  #remove header
end

def to_tsv(filename)
  out_filename = "#{filename[0..-4]}tsv"
  `sed -i 's/,/	/g' #{filename}` #remove commas
  `mv #{filename} #{out_filename}`
  out_filename
end

def concatenate(filename,out_dir,month,year)
   puts "Concatenating #{month} #{year}"
   out_file = "#{out_dir}/#{year}.#{(Settings.to_tsv)? 'tsv':'csv'}"
   `cat #{filename} >> #{out_file}`
   `rm #{filename}`
end

def upload(out_dir,month,year)
  if month == MONTHS.last
    puts "Uploading #{year}.tsv to HDFS"
    `hdp-put #{out_dir}/#{year}.tsv #{Settings.hdfs_out}/#{year}.tsv`
    puts "Uploaded... Deleting local file..."
    `rm #{out_dir}/#{year}.tsv`
  end
end

def post_process(year,month,out_dir)
   puts "Postprocessing #{month} #{year}"
   filename = "#{out_dir}/#{month}-#{year}.csv"
   transform filename
   filename = to_tsv filename if Settings.to_tsv
   concatenate(filename,out_dir,month,year) if Settings.concatenate
   upload(out_dir,month,year) if Settings.hdp_put    
end

if Settings.production
  Settings.concatenate = true
  Settings.remove_header = true
  Settings.to_tsv = true
  Settings.unzip = true
  Settings.hdp_put = true
end

Settings.concatenate = true if Settings.hdp_put

if Settings.year.nil?
  Settings.year = YEARS
else
  Settings.year = [Settings.year]
end

if Settings.month.nil?
  Settings.month = MONTHS
else
  Settings.month = [Settings.month]
end

Settings.year.each do |year|
  Settings.month.each_with_index do |month,index|
    download(year,month,Settings.out_dir)
    unzip(year,month,Settings.out_dir) if Settings.unzip
    post_process(year,month,Settings.out_dir)
  end
end
