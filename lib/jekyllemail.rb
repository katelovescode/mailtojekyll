#!/usr/bin/env ruby

require 'mail'
require 'nokogiri'
require 'reverse_markdown'

class JekyllEmail
  
  include Mail

  attr_reader :atts, :title, :body
  
  def initialize(thismail)
    # empties
    @atts = {}
    body = ""
    
    # process w/ mail gem
    thismail = Mail.read(thismail)    
    
    # get the subject for validation & split to get title/secret
    @subject = thismail.subject
    (@title, @secret) = (@subject.split((/\|\|/))).collect { |x| x.strip } unless @subject.nil?
    
    # list the attachments & save them
    thismail.attachments.each_with_index do |att,idx|
      if att.content_type.start_with?("image/")
        filename = att.filename.gsub(/[^0-9a-z. ]/i, ' ')
        filename = filename.split(" ").join("-")
        cid = att.content_id.to_s.delete("<>")
        @atts["image#{idx}".to_sym] = {filename: filename, cid: cid, content: att.body.decoded, type: att.content_type}
      end      
    end
    
    # process the body with markdown and blanktest
    if thismail.multipart?
      !thismail.html_part.nil? ? body = thismail.html_part.decoded : body = thismail.text_part.decoded
    else
      body = thismail.body.decoded.gsub(/\n{2}/,"<br><br>")
    end
    body = markdown(body)
    if blanktest(body)
      thismail.has_attachments? ? body = " " : body = ""
    end
    @body = body
    
  end
  
  # validate the subject; if valid, return title
  def validate_subject
    if @subject.nil?
      raise StandardError, "No subject"
    else
      @title.strip
    end
  end
  
  # validate the secret; no return
  def validate_secret # parse the title for the secret
    unless @secret.nil?
      (key, @secret) = @secret.split(/:\s?/)
      @secret.strip!
    end
    if (@secret.nil? || @secret != "jekyllmail")
      raise StandardError, "Secret incorrect or missing" 
    end
  end
  
  # validate the body
  def validate_body
    if @body == ""
      raise StandardError, "No body text" 
    end
  end
  
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
    isblank = doc.gsub(badspc,"").gsub(nbsp,"").gsub("\&nbsp;","").gsub(/\n/,"").gsub(/\s+/,"")
    if isblank == ""
      blank = true
    else
      blank = false
    end

  end
  
end