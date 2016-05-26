require 'json'
require 'date'

outfile = File.open('yemen_tweets_5.22.2016_timeseries.csv','w')
outfile << "id;posted_time;year;month;day;hour;minute;second;millisecond\n"

row = 0

open('yemen_tweets_5.22.2016').each do |line|

	data = JSON.parse(line)
	
	row = row + 1
	
	outfile << "#{data['_source']['norm']['id']};#{data['_source']['norm']['timestamp']};"

	# print "#{data['_source']['norm']['timestamp']}"

			# 2016-05-01T07:51:42+00:00
	posted_time = DateTime.strptime( data['_source']['norm']['timestamp'], '%Y-%m-%dT%H:%M:%S%z' )

	outfile << "#{posted_time.strftime('%Y;%m;%d;%H;%M;%S;%L')}\n"
 	
	print "#{row}\n" if row % 10000 == 0

end
