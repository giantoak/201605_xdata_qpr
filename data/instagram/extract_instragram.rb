require 'date'
require 'json'

unless ARGV.length == 2
	print "usage: ruby extract_instagram.rb [instagram_data] [csv output file]\n"
	exit
end

file = File.open(ARGV[1],'w')

file << "instagram_id, epoch, date_time, location_id, location_name, location_latitude, location_longitude\n"

row =  0

open(ARGV[0],'r').each do |line|

	data = JSON.parse( line )

	id = data['_id']
	epoch = data["_source"]["created_time"]
	location = data["_source"]["location"]
		
	location_id = ''
	location_latitude = ''
	location_longitude = ''
	location_name = ''

	unless data["_source"]["location"].nil?
		location_id = data["_source"]["location"]["id"]
      location_name = data["_source"]["location"]["name"]
      location_latitude = data["_source"]["location"]["latitude"]
      location_longitude = data["_source"]["location"]["longitude"]
	end

	file << "#{id},#{epoch},#{Time.at(epoch.to_i)},#{location_id},#{location_name},#{location_latitude},#{location_longitude}\n"

	row = row + 1

	print "#{row}\n" if row % 50000 == 0

end
