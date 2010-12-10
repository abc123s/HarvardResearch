#Math webscraper, to grab professor information (contact, research topics, etc)

#!/usr/local/bin/ruby -w

#require needed gems 
require 'nokogiri'
require 'open-uri'

#create new text file
aFile = File.new(ARGV[0], "w")

#open url via Nokogiri, and save in doc
doc = Nokogiri::HTML(open(ARGV[1]))

# use various techniques (regex and css selectors) to capture the data we're
# interested in, and convert into csv format, so we can write it to our file
tr = doc.css('table.raster > tr')
tr.each do |row|
  td = row.css('td')
  aFile.syswrite("\""+ td[1].to_s.gsub(/<.*?>/, '').gsub(/\n/, '') + "\",")
  aFile.syswrite(td[2].to_s.gsub(/<.*?>/, '').gsub(/office:/, '') + ", ")
  aFile.syswrite(td[3].to_s.gsub(/<.*?>/, '').gsub(/tel:/, '') + ", ")		
  aFile.syswrite(td[4].to_s.gsub(/<.*?>/, '').gsub(/\n/, '').gsub(/\s/, '').gsub(/email:/, '') + ".harvard.edu, ")
  row.css('a').each do |link|
    if link[ 'href' ] =~ /http.*/
      aFile.syswrite(link[ 'href' ].to_s + "\n")
      break
    elsif link[ 'href' ] =~ /.+/
      aFile.syswrite("http://www.math.harvard.edu/people/" + link[ 'href' ].to_s + "\n")
      break
    end    
  end
end

#close text file
aFile.close

    
