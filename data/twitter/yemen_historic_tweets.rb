require 'json'
require 'date'

outfile = File.open('yemen_historic_tweets_timeseries.csv','w')
outfile << "id;posted_time;year;month;day;hour;minute;second;millisecond\n"

row = 0

open('yemen_historic_tweets').each do |line|

	data = JSON.parse(line)
	
	row = row + 1
	
	outfile << "#{data['id']};#{data['postedTime']};"

#	print "#{data['postedTime']}"

			# 2014-08-10T01:59:02.000Z
	posted_time = DateTime.strptime( data['postedTime'], '%Y-%m-%dT%H:%M:%S.%L' )

	outfile << "#{posted_time.strftime('%Y;%m;%d;%H;%M;%S;%L')}\n"
 	
	print "#{row}\n" if row % 10000 == 0

end
