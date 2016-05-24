#!/bin/ruby
#
#      AUTHOR: Matt Parker (matt.parker@giantoak.com)
#     CREATED: May 24, 2016
# DESCRIPTION: Extract telegram data from telegram html file
#
require 'date'
require 'nokogiri'
require 'open-uri'

puts "ARGS length: #{ARGV.length}\n"

unless ARGV.length==2
	puts "usage: ruby channelscraper.rb [channel html file] [csv output file]\n" 
	exit
end

	# Stage files
data = open( ARGV[1], 'w')
data << "id, date, views, author, message\n"

doc = Nokogiri::HTML(open(ARGV[0]))

message_date = ''
record = 0

	# Process channel content
doc.xpath('//div').each do |div|

	if div['class'] == 'im_service_message' then

		span = div.at("span[@class='im_message_date_split_text']")

		if span
			parsed_date = DateTime.strptime( span.text.split(",",2)[1].strip, '%B %d, %Y'  )
			message_date = parsed_date.strftime('%m/%d/%Y' ) 
		end
		
	elsif div['class'] =~ /^im_message_wrap/ then

		message_views = ''
		message_author = ''
		message_text = ''

		span = div.at("span[@class='im_message_views_cnt']")
		message_views = span.text if span
		
		span = div.at("a[@class='im_message_author']")
		message_author = span.text if span

		span = div.at("div[@class='im_message_text']")
		
		if span
			temp = span.text
			temp = span.text.split('@')[0] if temp =~ /@/ 
			temp = temp.split('www')[0] if temp =~ /www/
			temp = temp.gsub(/Telegram\.me\/A11AAbot/,'') 
			message_text = temp.gsub(/:\w+:/,'').strip
		end
		
		unless message_text == ''
			print "date: #{message_date} views: #{message_views} author: #{message_author} text: #{message_text}\n"
			record = record + 1
			data << "#{record},#{message_date},#{message_views},#{message_author},#{message_text}\n"
		end

	end
		
end

