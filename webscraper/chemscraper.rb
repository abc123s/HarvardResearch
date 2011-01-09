#Chem webscraper, to grab professor information (contact, research topics, etc)

#/usr/local/bin/ruby -w

#require needed gems 
require 'nokogiri'
require 'open-uri'

#open new text file
aFile = File.new(ARGV[0], "w")

#open url via Nokogiri, and store in doc
doc = Nokogiri::HTML(open(ARGV[1]))

#use various techniques (regex and css selectors) to capture the relevant data, #and convert it to csv format, to write into text file.
i = 2
list = doc.css('table table table')[3].css('tr')
while(i <  list.length)
  if i == 98 or i == 120 or i == 130 or i == 160 or i == 162 or i == 164
    i = i + 2
    if i == 132
      i = i + 1
    end
  elsif i == 145
    aFile.syswrite("\"" + list[i].to_s.gsub(/<.*?>/, '').gsub(/\n/, '').gsub(/(\s)+/, ' ') + "\",")
    aFile.syswrite("\"\",\"\",")
    aFile.syswrite("\"" + list[i+1].to_s.gsub(/<.*?>/, '').gsub(/\n/, '').gsub(/(\s)+/, ' ').gsub(/ AT /, '@').gsub(/ Area: /, '').gsub(/Tel: /, '","')  +"\",\"")    
    aFile.syswrite("\",\"")
    if list[i].css('a')[0][ 'href' ] =~ /http.*/
      aFile.syswrite(list[i].css('a')[0][ 'href' ].to_s + "\"\n")
    else
      aFile.syswrite("http://www.chem.harvard.edu/" + list[i].css('a')[0][ 'href' ].to_s + "\"\n")
    end
    i = i + 3
  elsif i > 98 and i < 120
    aFile.syswrite("\"" + list[i].to_s.gsub(/<.*?>/, '').gsub(/\n/, '').gsub(/(\s)+/, ' ') + "\",")
    aFile.syswrite("\"" + list[i+1].to_s.gsub(/<.*?>/, '').gsub(/\n/, '').gsub(/(\s)+/, ' ').gsub(/ AT /, '@').gsub(/ E-mail: /, '').gsub(/ Tel: /, '","') + "\",") 
    aFile.syswrite("\"" + list[i+2].to_s.gsub(/<.*?>/, '').gsub(/\n/, '').gsub(/(\s)+/, ' ').gsub(/ Area: /, '').gsub(/ Fax: /, '","') + "\",") 
    aFile.syswrite("\"" + list[i+3].to_s.gsub(/<.*?>/, '').gsub(/\n/, '').gsub(/(\s)+/, ' ').gsub(/ Department:/, '') + "\",\"")
    if list[i].css('a')[0][ 'href' ] =~ /http.*/
      aFile.syswrite(list[i].css('a')[0][ 'href' ].to_s + "\"\n")
    else
      aFile.syswrite("http://www.chem.harvard.edu/" + list[i].css('a')[0][ 'href' ].to_s + "\"\n")
    end
    i = i + 5
  else 
    aFile.syswrite("\"" + list[i].to_s.gsub(/<.*?>/, '').gsub(/\n/, '').gsub(/(\s)+/, ' ') + "\",")
    aFile.syswrite("\"" + list[i+1].to_s.gsub(/<.*?>/, '').gsub(/\n/, '').gsub(/(\s)+/, ' ').gsub(/ AT /, '@').gsub(/ E-mail: /, '').gsub(/ Tel: /, '","')  + "\",") 
    aFile.syswrite("\"" + list[i+2].to_s.gsub(/<.*?>/, '').gsub(/\n/, '').gsub(/(\s)+/, ' ').gsub(/ Area: /, '').gsub(/ Fax: /, '","') + "\",\"")
    aFile.syswrite("\",\"")
    if !list[i].css('a').empty?  
      if list[i].css('a')[0][ 'href' ]  =~ /http.*/
        aFile.syswrite(list[i].css('a')[0][ 'href' ].to_s + "\"\n")
      else
        aFile.syswrite("http://www.chem.harvard.edu/" + list[i].css('a')[0][ 'href' ].to_s + "\"\n")
      end
    else
      aFile.syswrite("\",\"\"\n")
    end
    i = i + 4
  end
end 

#close text file
aFile.close
 
