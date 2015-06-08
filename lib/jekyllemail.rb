require 'mail'
require 'nokogiri'

class JekyllEmail
  
  include Mail
  
  def initialize(thismail)
    thismail = Mail.read(thismail)
    @subject = thismail.subject
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
    if @subject.nil?
      raise StandardError, "No subject"
    # else
    #   puts @subject
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
      puts "Body exists"
    end
  end
  
end

# TESTING BLOCK

path = 'spec/mocks/'
device = 'outlook/'
# mail = JekyllEmail.new( path + device + 'no-subject.eml' )
# mail = JekyllEmail.new( path + device + 'empty.eml' )
# mail = JekyllEmail.new( path + device + 'no-secret.eml' )
# mail = JekyllEmail.new( path + device + 'wrong-secret.eml' )
mail = JekyllEmail.new( path + device + 'attached-inline.eml' )
# mail = JekyllEmail.new( path + device + 'attached-text.eml' )
# mail = JekyllEmail.new( path + device + 'attached-no-text.eml' )
# mail = JekyllEmail.new( path + device + 'inline.eml' )
# mail = JekyllEmail.new( path + device + 'emoji.eml' )
# mail = JekyllEmail.new( path + device + 'html-format.eml' )
# mail = JekyllEmail.new( path + device + 'html-no-format.eml' )
# mail = JekyllEmail.new( path + device + 'plain-text.eml' )

# mail.p_bod
