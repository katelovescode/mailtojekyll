#!/usr/bin/env ruby

require 'mail'
require 'nokogiri'
require 'reverse_markdown'
require_relative 'striphtml'

class JekyllEmail
  
  include Mail
  
  def initialize(thismail)
    thismail = Mail.read(thismail)    
    @subject = thismail.subject
    (@title, @secret) = @subject.split((/\|\|/)) unless @subject.nil?    
    
    if thismail.multipart?
      !thismail.html_part.nil? ? @body = striphtml(thismail.html_part.decoded) : @body = striphtml(thismail.body.decoded)
      if @body == "" && thismail.has_attachments?
        @body = " "
      end
    else
      @body = striphtml(thismail.body.decoded)
    end
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
  
  # validate the body; return body
  def v_bod
    if @body == ""
      raise StandardError, "No body text" 
    else
      # strip = Nokogiri::HTML(decode).at("body").inner_text.gsub(/\s+/,"").length        
      # if strip == 0 && !thismail.has_attachments?
      #   @body = ""
      # else
      # puts "body incoming!"
      # puts @body
    end
  end
  
end