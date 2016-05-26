require 'csv'
require 'date'

unless ARGV.length == 1
	print "usage: ruby split_by_date.rb [csv file]\n"
end

print "Processing #{ARGV[0]}...\n"

CSV.open( ARGV[0] ).each do |row|
	
	unless row[5] == '' && row[6] == ''

		filename = "data/#{row[2][0..9]}.txt"
	
		unless File.exists?( filename )
			open( filename, 'w' ) do |header|
				header << "instagram_id,date_time,latitude,longitude\n"
			end
		end

		open( filename, 'a+' ) do |file|
			file << "#{row[0]},#{row[2]},#{row[5]},#{row[6]}\n"
		end

	end

end

print "Done.\n"
