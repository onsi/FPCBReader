require 'rubygems'
require 'icalendar'
require 'date'
require 'CSV'
require 'uri'

fname = "SpringReadings"

cal = Icalendar::Calendar.new

i = 0
CSV.foreach("#{fname}.csv") do |row|
  if i == 0
    i += 1
    next
  end
  
  cal.event do
    reading_date = Date.new(row[2].to_i,row[1].to_i,row[0].to_i)
    dtstart   reading_date
    dtend     reading_date + 1
    summary   row[3]
    url       URI.escape("http://mobile.biblegateway.com/passage/?search=#{row[3]}&version=ESV")
  end
end

f = open("#{fname}.ics", 'w')
f << cal.to_ical
f.close