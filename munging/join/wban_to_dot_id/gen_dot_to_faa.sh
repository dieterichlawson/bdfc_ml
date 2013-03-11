# Download flight support table
curl -L -d 'UserTableName=Master_Coordinate&DBShortName=Aviation_Support_Tables&RawDataTable=T_MASTER_CORD&sqlstr=+SELECT+AIRPORT_ID%2CAIRPORT%2CAIRPORT_COUNTRY_CODE_ISO+FROM++T_MASTER_CORD&varlist=AIRPORT_ID%2CAIRPORT%2CAIRPORT_COUNTRY_CODE_ISO&grouplist=&suml=&sumRegion=&filter1=title%3D&filter2=title%3D&geo=Not+Applicable&time=Not+Applicable&timename=N%2FA&GEOGRAPHY=All&XYEAR=All&FREQUENCY=All&VarDesc=AirportSeqID&VarType=Num&VarName=AIRPORT_ID&VarDesc=AirportID&VarType=Num&VarName=AIRPORT&VarDesc=Airport&VarType=Char&VarDesc=AirportName&VarType=Char&VarDesc=AirportCityName&VarType=Char&VarDesc=AirportWacSeqID2&VarType=Num&VarDesc=AirportWac&VarType=Num&VarDesc=AirportCountryName&VarType=Char&VarName=AIRPORT_COUNTRY_CODE_ISO&VarDesc=AirportCountryCodeISO&VarType=Char&VarDesc=AirportStateName&VarType=Char&VarDesc=AirportStateCode&VarType=Char&VarDesc=AirportStateFips&VarType=Char&VarDesc=CityMarketSeqID&VarType=Num&VarDesc=CityMarketID&VarType=Num&VarDesc=CityMarketName&VarType=Char&VarDesc=CityMarketWacSeqID2&VarType=Num&VarDesc=CityMarketWac&VarType=Num&VarDesc=LatDegrees&VarType=Num&VarDesc=LatHemisphere&VarType=Char&VarDesc=LatMinutes&VarType=Num&VarDesc=LatSeconds&VarType=Num&VarDesc=Latitude&VarType=Num&VarDesc=LonDegrees&VarType=Num&VarDesc=LonHemisphere&VarType=Char&VarDesc=LonMinutes&VarType=Num&VarDesc=LonSeconds&VarType=Num&VarDesc=Longitude&VarType=Num&VarDesc=UTCLocalTimeVariation&VarType=Char&VarDesc=AirportStartDate&VarType=Char&VarDesc=AirportEndDate&VarType=Char&VarDesc=AirportIsClosed&VarType=Num&VarDesc=AirportIsLatest&VarType=Num' 'http://transtats.bts.gov/DownLoad_Table.asp?Table_ID=288&Has_Group=0&Is_Zipped=0' > dot_id_to_faa.zip
unzip -d dot_id_to_faa dot_id_to_faa.zip
mv dot_id_to_faa/*.csv ./dot_id_to_faa.csv
rm -r dot_id_to_faa && rm dot_id_to_faa.zip
# turn into TSV
sed -i '' 's/,/	/g' dot_id_to_faa.csv && mv dot_id_to_faa.csv dot_id_to_faa.tsv
# remove quotes
sed -i '' 's/"//g' dot_id_to_faa.tsv
# only USA airports
awk '$3 ~ /^US$/' dot_id_to_faa.tsv > dot_id_to_faa.tsv.tmp
rm dot_id_to_faa.tsv
# unique entries only
awk '{print $1,$2}' dot_id_to_faa.tsv.tmp | sort -k2 | uniq > dot_id_to_faa.tsv
# turn into tsv again
sed -i '' 's/ /	/g' dot_id_to_faa.tsv
rm dot_id_to_faa.tsv.tmp
