require 'json'
require 'date'

require 'georuby'
require 'geo_ruby/ewk'        # EWKT/EWKB
require 'geo_ruby/shp'        # Shapefile
require 'geo_ruby/gpx'        # GPX data
require 'geo_ruby/kml'        # KML data
require 'geo_ruby/georss'     # GeoRSS
require 'geo_ruby/geojson'    # GeoJSON

require './provinces'

outfile = File.open(ARGV[1],'w')
outfile << "id;posted_time;district;province;country_code;latitude;longitude;year;month;day;hour;minute;second;millisecond\n"

province = Province.new('provinces.csv')

row = 0

open(ARGV[0]).each do |line|

	data = JSON.parse(line)
	
	row = row + 1
	# print "row: #{row}\n"

	message_type = ''

	if data.has_key?('objectType')
		message_type = data['objectType']
	elsif data.has_key?('_type')
		message_type = data['_type']
	else
		print "cant' find message type for #{row}.\n"
		print data
		exit
	end

	country_code = ''
	x = 0
	y = 0
 
	if message_type == 'activity'
		country_code == data['location']['twitter_country_code'] if data.has_key?('location')
		coordinates = data['geo']['coordinates']
		x = coordinates[1]
		y = coordinates[0]
	# elsif message_type == 'person'
	# 	country_code == ''
	#	coordinates = data['location']['geo']['coordinates']
	#	x = 0
	#	y =0 
	elsif message_type == 'tweet_traptor'
		
		unless data['_source']['doc']['place'].nil?
			country_code = data['_source']['doc']['place']['country_code']
			coordinates = data['_source']['doc']['place']['bounding_box']['coordinates']
			x = coordinates[0][0][0]+coordinates[0][2][0]/2
			y = coordinates[0][0][1]+coordinates[0][2][1]/2
		else
			coordinates = data['_source']['doc']['geo']['coordinates']
			x = coordinates[1]
			y = coordinates[0]
		end
	end

	print "row: #{row} mt: #{message_type} cc: #{country_code}  x: #{x} y: #{y}\n"

	point = GeoRuby::SimpleFeatures::Point.from_coordinates([x,y],4326)
	label = province.contains(point)
	label = "none, none" if label == ''

	outfile << "#{data['_id']};#{data['_source']['norm']['timestamp']};#{label.gsub(/,/,';')};"

			# 2014-08-10T01:59:02.000Z
	posted_time = DateTime.strptime( data['_source']['norm']['timestamp'], '%Y-%m-%dT%H:%M:%S%z' )
	outfile << "#{country_code};#{y};#{x};#{posted_time.strftime('%Y;%m;%d;%H;%M;%S;%L')}\n"
 
	# print "#{row}\n" if row % 10000 == 0

end
