require 'date'
require 'json'

file = File.open('instagram_yemen_odo_user_posts.csv','w')

file << "instagram_id, epoch, date_time, location_id, location_name, location_latitude, location_longitude\n"

row =  0

open('instagram_yemen_odo_user_posts','r').each do |line|

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
