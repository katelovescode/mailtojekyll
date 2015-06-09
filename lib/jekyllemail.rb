require 'mail'
require 'net/pop'
require 'nokogiri'
require 'fileutils'

class JekyllEmail
  
  include Mail
  
  def initialize(thismail)
    thismail = Mail.read(thismail)    
    @subject = thismail.subject
    puts @subject
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
  
  def p_sub
    puts @subject.nil?
    if @subject.nil?
      raise StandardError, "No subject"
    else
      puts @subject
    end
  end
  
  def p_sec # parse the title for the secret
    (@title, secret) = @subject.split((/\|\|/)) unless @subject.nil?
    unless secret.nil?
      (key, @secret) = secret.split(/:\s?/)
      @secret.strip!
    end
    raise StandardError, "Secret incorrect" if (@secret.nil? || @secret != "jekyllmail")
  end
  
  def p_bod
    emptylength = Nokogiri::HTML(@body).inner_text.gsub(/\s+/,"").length
    if emptylength == 0 || @body == ""
      unless @has_attachments
        raise StandardError, "No body text"
      end
    else
      # puts "Body exists"
    end
  end
  
end

# TESTING BLOCK

path = 'spec/mocks/'
device = 'gmail/'
mail1 = JekyllEmail.new( path + device + 'no-subject.eml' )
mail2 = JekyllEmail.new( path + device + 'empty.eml' )
mail3 = JekyllEmail.new( path + device + 'no-secret.eml' )
mail4 = JekyllEmail.new( path + device + 'wrong-secret.eml' )
mail5 = JekyllEmail.new( path + device + 'attached-inline.eml' )
mail6 = JekyllEmail.new( path + device + 'attached-text.eml' )
mail7 = JekyllEmail.new( path + device + 'attached-no-text.eml' )
mail8 = JekyllEmail.new( path + device + 'inline.eml' )
mail9 = JekyllEmail.new( path + device + 'emoji.eml' )
mail10 = JekyllEmail.new( path + device + 'html-format.eml' )
mail11 = JekyllEmail.new( path + device + 'html-no-format.eml' )
mail12 = JekyllEmail.new( path + device + 'plain-text.eml' )