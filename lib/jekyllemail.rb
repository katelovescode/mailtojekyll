require 'mail'
require 'net/pop'
require 'nokogiri'
require 'fileutils'

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

mail.p_sub

# # TESTING TO PULL OUTLOOK EMAILS?
# 
# Mail.defaults do
#   mail_settings = {
#     address: "pop.gmail.com",
#     port: 995,
#     user_name: "jekylltester@gmail.com",
#     password: "r5OMZwdfH42i",
#     enable_ssl: true
#   }
#   retriever_method :pop3, mail_settings
# end
# 
# # emails is a list of all pop3 retrieved emails
# emails = Mail.all
# 
# emails.each_with_index do |email,idx|
#   
#   # filename = '/tmp/mocks/outlook/' + email.subject.to_s + '.eml'
#   # 
#   # FileUtils.mkdir_p('/tmp/mocks/outlook/')
#   # 
#   # File.open(filename,'w'){ |f| f.write(YAML.dump(email)) }
# 
#   subj = email.subject
#   if email.subject.nil?
#     subj = "(no subject)"
#   else
#     subj = email.subject
#   end
#   mpt = email.multipart?
#   if mpt
#     lng = email.parts.length
#   else
#     lng = "not multipart"
#   end
#   puts subj + " | multipart: " + mpt.to_s + " | length: " + lng.to_s
# end
