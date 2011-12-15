require 'CSV'

fname = "WinterReadings"

f = open("#{fname}.plist", 'w')

f << """<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<array>"""

i = 0
CSV.foreach("#{fname}.csv") do |row|
  if i == 0
    i += 1
    next
  end
  
  f << """
  <dict>
		<key>day</key>
		<integer>#{row[0]}</integer>
		<key>month</key>
		<integer>#{row[1]}</integer>
		<key>year</key>
		<integer>#{row[2]}</integer>
		<key>reference</key>
		<string>#{row[3]}</string>
	</dict>"""
end

f << "\n</array>\n</plist>"

f.close