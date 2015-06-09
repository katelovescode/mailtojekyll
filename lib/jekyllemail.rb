#!/usr/bin/env ruby

require 'mail'
require 'nokogiri'
require_relative 'striphtml'

class JekyllEmail
  
  include Mail

  attr_reader :atts
  attr_reader :title
  attr_reader :body
  
  def initialize(thismail)
    
    @atts = {}
    
    thismail = Mail.read(thismail)    
    
    # get the subject for validation
    @subject = thismail.subject
    
    # split the subject to get the title for creating posts and the secret for validation
    (@title, @secret) = (@subject.split((/\|\|/))).collect { |x| x.strip } unless @subject.nil?
    
    thismail.attachments.each do |att|
      fn = att.filename
      cid = att.content_id.to_s.delete("<>")
      @atts[fn] = cid
    end
    
    # process the body with the striphtml method    
    if thismail.multipart?
      !thismail.html_part.nil? ? @body = striphtml(thismail.html_part.decoded) : @body = striphtml(thismail.body.decoded)
      if @body == "" && thismail.has_attachments?
        @body = " "
      end
    else
      @body = striphtml(thismail.body.decoded)
    end
    @body.delete!("\u200b")
    
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