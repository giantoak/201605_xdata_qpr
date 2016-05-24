#!/bin/ruby

totals = {}
row = 0

open('whereistheboom.csv').each do |line|

	if row > 0 
		date = line.split(",")[1]
	
		if totals.has_key?( date )
			totals[ date ] = totals[ date ] + 1
		else
			totals[ date ] = 1
		end	
	end

	row = row + 1

end



file = open('whereistheboom-summary.csv','w')
file << "date,total\n"

totals.each do | key, value |
	print "#{key} -> #{value}\n"
	file << "#{key},#{value}\n"
end