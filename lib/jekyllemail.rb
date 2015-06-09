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
  
  # validate the subject
  def v_sub
    if @subject.nil?
      raise StandardError, "No subject"
    else
      # puts @subject
    end
  end
  
  # validate the secret
  def v_sec # parse the title for the secret
    unless @secret.nil?
      (key, @secret) = @secret.split(/:\s?/)
      @secret.strip!
    end
    raise StandardError, "Secret incorrect" if (@secret.nil? || @secret != "jekyllmail")
  end
  
  # validate the body
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
    else
      # puts clr
    end
  end
  
end

# TESTING BLOCK

# path = 'spec/mocks/'
# device = 'outlook/'
# mail1 = JekyllEmail.new( path + device + 'no-subject.eml' )
# mail2 = JekyllEmail.new( path + device + 'empty.eml' )
# mail3 = JekyllEmail.new( path + device + 'no-secret.eml' )
# mail4 = JekyllEmail.new( path + device + 'wrong-secret.eml' )
# mail5 = JekyllEmail.new( path + device + 'attached-inline.eml' )
# mail6 = JekyllEmail.new( path + device + 'attached-text.eml' )
# mail7 = JekyllEmail.new( path + device + 'attached-no-text.eml' )
# mail8 = JekyllEmail.new( path + device + 'inline.eml' )
# mail9 = JekyllEmail.new( path + device + 'emoji.eml' )
# mail10 = JekyllEmail.new( path + device + 'html-format.eml' )
# mail11 = JekyllEmail.new( path + device + 'html-no-format.eml' )
# mail12 = JekyllEmail.new( path + device + 'plain-text.eml' )
# 
# mail2.v_bod