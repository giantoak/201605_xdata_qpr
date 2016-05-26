#!/bin/bash

alias ruby='/opt/rubystack-2.2.5-3/ruby/bin/ruby'

rm whereistheboom.csv
rm whereistheboom_summary.csv
rm yementodaychannl.csv
rm yementodaychannl_summary.csv 

/opt/rubystack-2.2.5-3/ruby/bin/ruby channel_scraper.rb whereistheboom.html whereistheboom.csv whereistheboom-messages-arabic.txt
/opt/rubystack-2.2.5-3/ruby/bin/ruby channel_summary.rb whereistheboom.csv whereistheboom_summary.csv 

/opt/rubystack-2.2.5-3/ruby/bin/ruby channel_scraper.rb yementodaychannl.html yementodaychannl.csv yemetodaychannl-messages-arabic.txt
/opt/rubystack-2.2.5-3/ruby/bin/ruby channel_scraper.rb yementodaychannl.csv yementodaychannl_summary.csv
