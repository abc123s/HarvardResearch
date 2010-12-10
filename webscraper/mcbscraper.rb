#MCB webscraper, to grab professor information (contact, research topics, etc)

#!/usr/local/bin/ruby -w

#require needed gems 
require 'nokogiri'
require 'open-uri'

#open new text file
aFile = File.new(ARGV[0], "w")

#open url via Nokogiri, and store in doc
doc = Nokogiri::HTML(open(ARGV[1]))

#use various techniques (regex, and css selectors) to capture the relevant data
#and then convert to csv file format, to store in file.
doc.css('tr').each do |link| 
  if !link.css('a').empty?
      if link.css('a').to_s =~ /\/Search|\/index.html/
      else  
        url = "http://mcb.harvard.edu/Faculty/" + link.css('a').first[ 'href' ].to_s
        profile = Nokogiri::HTML(open(url))
        facultyinfo =  profile.css('table')[1].css('td')[2]
        aFile.syswrite(facultyinfo.to_s.gsub(/.*<!-- name -->|<!-- title -->.*/m, '"').gsub(/(<br.*?>)/, ' ').gsub(/<.*?>/, '') + ",") 
aFile.syswrite(facultyinfo.to_s.gsub(/.*<!-- title -->|<!-- contact -->.*/m, '"').gsub(/(<br.*?>)/, ', ').gsub(/<.*?>/, '') + ",")
	aFile.syswrite(facultyinfo.to_s.gsub(/.*<!-- contact -->|<!-- links-->.*/m, '"').gsub(/(\s)+/, ' ').gsub(/(<br.*?>)/, '","').gsub(/","Email: |Phone: |Mail: /, '').gsub(/<.*?>/, '') + ",") 
        aFile.syswrite("\"" + profile.to_s.gsub(/.*<!-- research information -->|<!-- publications -->.*/m, '').gsub(/<.*?>/, '').gsub(/(\s)+|\n/, ' ') + "\"\n")
      end
  end
end

#close text file
aFile.close
   
