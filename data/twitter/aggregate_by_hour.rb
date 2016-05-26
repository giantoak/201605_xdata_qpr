require 'date'

INDEX_ID = 0
INDEX_DATE = 1
INDEX_YEAR = 2
INDEX_MONTH = 3
INDEX_DAY = 4
INDEX_HOUR = 5
INDEX_MINUTE = 6

row = 0

totals = {}

open('yemen_tweets_5.22.2016_timeseries.csv').each do |line|

	unless row == 0
		data = line.split(";")
		key = "#{data[INDEX_YEAR]}-#{data[INDEX_MONTH]}-#{data[INDEX_DAY]}-#{data[INDEX_HOUR]}"

		if totals.has_key?( key )
			totals[key] = totals[key] + 1
		else
			totals[key] = 1
		end 		
	end

	row = row + 1

end

print "#{totals.size} entries..\n"

file = File.open('yemen_tweets_5.22.2016.by_hour.csv','w')
file << "index,hour,message_total\n"

totals.each do | key, value |
	print "#{key} -> #{value}\n"
	indicies = key.split("-")
	print "#{indicies}\n\n"
	index = DateTime.new(indicies[0].to_i,indicies[1].to_i,indicies[2].to_i,indicies[3].to_i,0,0)
	file << "#{index.strftime('%s')},#{key},#{value}\n"
end
