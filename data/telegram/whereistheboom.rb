#!/bin/ruby
#
#      AUTHOR: Matt Parker (matt.parker@giantoak.com)
#     CREATED: May 23, 2016
# DESCRIPTION: Extract telegram data from whereistheboom.html
#
require 'nokogiri'
require 'open-uri'

data = open('whereistheboom.csv','w')
data << "id, date, views, author, message\n"

doc = Nokogiri::HTML(open('whereistheboom.html'))

message_long_date = ''
record = 0

doc.xpath('//div').each do |div|

	if div['class'] == 'im_service_message' then

		span = div.at("span[@class='im_message_date_split_text']")
		message_long_date = span.text if span

	elsif div['class'] =~ /^im_message_wrap/ then

		message_views = ''
		message_author = ''
		message_text = ''

		span = div.at("span[@class='im_message_views_cnt']")
		message_views = span.text if span
		
		span = div.at("a[@class='im_message_author']")
		message_author = span.text if span

		span = div.at("div[@class='im_message_text']")
		message_text = span.text.split('@')[0] if span

		unless message_text == ''
			print "date: #{message_long_date} views: #{message_views} author: #{message_author} text: #{message_text}\n"
			record = record + 1
			data << "#{record},#{message_long_date},#{message_views},#{message_author},#{message_text}\n"
		end

	end
		
end
