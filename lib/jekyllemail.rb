require 'mail'
require 'nokogiri'

class JekyllEmail
  
  include Mail
  
  def initialize(thismail)
    thismail = Mail.read(thismail)
    @subject = thismail.subject
    if thismail.multipart?
      @body = thismail.html_part.decoded.delete("\u200b")
    else
      @body = thismail.body.decoded
    end
  end
  
  def p_sub
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
      # unless email.attachments.length > 0
        raise StandardError, "No body text"
      # end
    end
  end
  
end

# TESTING BLOCK

# mail2 = JekyllEmail.new('spec/mocks/gmail-empty.eml') 
# mail2.p_bod
