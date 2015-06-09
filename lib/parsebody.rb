def parsebody(email)
  
  doc = Nokogiri::HTML(email)

  # error testing
  # if (doc.errors.any?)
  #   puts "doc.errors:"
  #   doc.errors.each do |e|
  #     puts "#{ e.line }: #{ e.to_s }"
  #   end
  #   puts
  # end

  # strip out internal divs except img & br
  until doc.search('//div').length == 0
    doc.search('//div').each do |n| 
      n.replace(n.inner_html)
    end
  end

  until doc.search('//p').length == 0
    doc.search('//p').each do |n|
      n.replace(n.inner_html)
    end
  end

  # strip out emojis
  doc.search('//img').each do |a|
    if a.key?('goomoji')
      a.remove
    end
  end
  
  if doc.at("body").nil?
    doc = ""
  else
    doc = doc.at("body").inner_html
  end
  
  nbsp = Nokogiri::HTML("&nbsp;").text
  blanktest = doc.gsub(/\n/,"").gsub(/\s+/,"").gsub(nbsp,"").gsub("<br>","")
  
  if blanktest.length == 0
    doc = ""
  end

end