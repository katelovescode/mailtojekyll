require 'mail'

class JekyllEmail
  
  include Mail
  
  def initialize(thismail)
    thismail = Mail.read(thismail)
    @subject = thismail.subject
  end
  
  def p_sub
    if @subject.nil?
      raise StandardError, "No subject"
    else
      puts @subject
    end
  end
  
  def p_sec
    (title, secret) = @subject.split((/\|\|/))
    unless secret.nil?
      (key, @secret) = secret.split(/:\s?/)
      @secret.strip!
    end

    raise StandardError, "Secret incorrect" unless @secret == "jekyllmail"
  end
  
end

# TESTING BLOCK

# mail2 = JekyllEmail.new('spec/mocks/gmail-no-subject.eml') 
# puts mail2.p_sub
