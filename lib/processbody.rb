#!/usr/bin/ruby

require 'nokogiri'
require 'reverse_markdown'

module ProcessBody
  
  def markdown(doc)
    doc = Nokogiri::HTML(doc)
    if doc.at("body").nil?
      doc = ""
    else
      doc = ReverseMarkdown.convert(doc.at("body").inner_html)
    end
  end
  
  
  def blanktest(doc)
    
    #strip out unicode character that gives us false blanks
    badspc = Nokogiri::HTML("&#8203;").text
    nbsp = Nokogiri::HTML("&nbsp;").text
    doc.gsub!(badspc,"")
    doc.gsub!(nbsp,"")
    doc.gsub!("\&nbsp;","")
    doc.gsub!(/\n/,"")
    doc.gsub!(/\s+/,"")
    if doc == ""
      blank = true
    else
      blank = false
    end
    
  end
end