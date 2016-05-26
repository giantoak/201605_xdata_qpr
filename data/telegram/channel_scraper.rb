#!/bin/ruby
#
#      AUTHOR: Matt Parker (matt.parker@giantoak.com)
#     CREATED: May 24, 2016
# DESCRIPTION: Extract telegram data from telegram html file
#
require 'date'
require 'nokogiri'
require 'open-uri'


unless ARGV.length == 3
	puts "usage: ruby channelscraper.rb [channel html file] [csv outfile] [arabic outfile]\n" 
	exit
end

	# Stage files
data = open( ARGV[1], 'w')
data << "id, date, time, views, author, message\n"

arabic = open( ARGV[2], 'w')

doc = Nokogiri::HTML( open(ARGV[0]) )

message_date = ''
record = 0

	# Process channel content
doc.xpath('//div').each do |div|

	if div['class'] == 'im_service_message' then

		span = div.at("span[@class='im_message_date_split_text']")

		if span
			parsed_date = DateTime.strptime( span.text.split(",",2)[1].strip, '%B %d, %Y'  )
			message_date = parsed_date.strftime('%Y/%m/%d' ) 
		end
		
	elsif div['class'] =~ /^im_message_wrap/ then

		message_views = 0
		message_author = ''
		message_text = ''
		message_time = ''

		span = div.at("span[@class='im_message_views_cnt']")
		message_views = span.text if span

		span = div.at("span[@class='im_message_author_wrap']/span/span")
		message_time = span.text if span
		
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
			print "date: #{message_date} time: #{message_time}, views: #{message_views} author: #{message_author} text: #{message_text}\n"
			record = record + 1
			arabic << "#{message_text}\n"
			data << "#{record},#{message_date},#{message_time},#{message_views},#{message_author},#{message_text}\n"
		end

	end
		
end

