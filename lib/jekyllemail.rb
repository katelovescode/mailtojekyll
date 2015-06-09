#!/usr/bin/env ruby

require 'mail'
require 'net/pop'
require 'nokogiri'
require 'fileutils'

class JekyllEmail
  
  include Mail
  
  def initialize(thismail)
    thismail = Mail.read(thismail)    
    @subject = thismail.subject
    (@title, @secret) = @subject.split((/\|\|/)) unless @subject.nil?
    if thismail.multipart?
      unless thismail.html_part.nil?
        @body = thismail.html_part.decoded.delete("\u200b")
      end
    else
      @body = thismail.body.decoded
    end
    if thismail.has_attachments?
      # puts "Has attachments"
      @has_attachments = true
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
    raise StandardError, "Secret incorrect" if (@secret.nil? || @secret != "jekyllmail")
  end
  
  # validate the body; return body
  def v_bod
    nbsp = 160.chr(Encoding::UTF_8)
    clr = Nokogiri::HTML(@body).at("body")
    unless clr.nil?
      clr = clr.inner_text.gsub(/\s+/,"").gsub(/\n/,"").gsub(nbsp,"")
    end
    if clr.nil? || clr.length == 0 || @body == ""
      unless @has_attachments
        raise StandardError, "No body text"
      end
    # else
      # puts clr
    end
  end
  
end