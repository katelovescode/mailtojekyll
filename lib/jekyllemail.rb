#!/usr/bin/env ruby

require 'mail'
require 'nokogiri'
require_relative 'processbody'

class JekyllEmail
  
  include Mail
  include ProcessBody

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
    
    # list the attachments
    thismail.attachments.each do |att|
      if att.content_type.start_with?("image/")
        fn = att.filename
        cid = att.content_id.to_s.delete("<>")
        @atts[fn] = cid
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
  def v_sub
    if @subject.nil?
      raise StandardError, "No subject"
    else
      @title.strip
    end
  end
  
  # validate the secret; no return
  def v_sec # parse the title for the secret
    unless @secret.nil?
      (key, @secret) = @secret.split(/:\s?/)
      @secret.strip!
    end
    if (@secret.nil? || @secret != "jekyllmail")
      raise StandardError, "Secret incorrect" 
    end
  end
  
  # validate the body
  def v_bod
    if @body == ""
      raise StandardError, "No body text" 
    end
  end
  
end