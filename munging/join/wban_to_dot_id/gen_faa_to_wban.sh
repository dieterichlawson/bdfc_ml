curl -L 'http://www.ncdc.noaa.gov/homr/file/mshr_enhanced.txt.zip' > mshr_enhanced.zip
unzip mshr_enhanced.zip && rm mshr_enhanced.zip
mv mshr_enhanced_*.txt mshr_enhanced.txt
