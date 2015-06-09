#!/usr/bin/env ruby

require 'mail'
require 'nokogiri'
require 'reverse_markdown'

require_relative 'jekyllemail'

# use or mixin the emailparser module? or include the emailparser code here
# loop through emails to create multiple Post objects (based on Post Class)
# each Post instantiates multiple Image objects (based on Image Class)

# Post has: Title, Date, Body, Images, Markdown file (save location)
# Image has: Alt text (maybe), file (save location)





# KATE'S LIST
# class for images, class for posts
# use "let" for rspec testing variables, like in rbemail
# body tests - check to make sure it exists, and check to make sure it is *exactly* what I want it to be (copy-paste the body of the email and format to final result, then code to make it pass)
# what order do the images come in?
# keep CID logic from JekyllMail
# turn parse into a module with smaller methods?
# TODO: Put the logic in to not run parse if the emails list is empty
# TODO: Figure something out for mail signatures

# class JekyllEmail < Mail
# 
#   def parsesubject
#     (title, secret) = self.subject.split(/\|\|/)
#   end
#     
#     #put parsed subject and created body into a settings hash and pass it in the constructor for JekyllPost - called automatically
#   
#   def makeit
#   end
#     #calls all the parsing, reading, etc. methods before it
# end
# 
# email = ('spec/mocks/whatever.eml')
# email = (loop through the pop account)
# 
# email = JekyllEmail.read(email)
# email.makeit # rspec checks this for subject, secret, body
# 
# post = JekyllPost.new(#settingshash)
# post.createsubject # rspec checks this for post title, body, images.
# # check for saving to the file system
# # check for saving images to the file system

# def parse(email)
# 
# 
# 
#   # parse the subject to create the title
#   @subject = email.subject
#   (@title, secret) = @subject.split(/\|\|/)
#   @title.strip!
# 
#   raise StandardError, "No subject" if @subject.nil? || @subject.empty?
# 
#   # parse the metadata to check for the secret and create additional key/value pairs
#   unless secret.nil?
#     (key, @secret) = secret.split(/:\s?/)
#     @secret.strip!
#   end
# 
#   raise StandardError, "Secret incorrect" unless @secret == "jekyllmail"
# 
#   # parse the body - if there are inline images, leave them in place
#   if email.multipart?
#     @body = email.html_part.decoded.delete("\u200b")
#     @body = Nokogiri::HTML.parse(@body).at("div")
#     @body.css("br").each { |node| node.replace('<br />') }
#     @body.css("div").each { |node| node.replace(node.inner_html)}
#     @body = @body.inner_html
#     @body = ReverseMarkdown.convert(@body)
#     if @body.gsub(/\s+/, "").length == 0
#       unless email.attachments.length > 0
#         @body == ""
#         raise StandardError, "Empty email"
#       end
#     end
#   else
#     @body = email.body.decoded
#     @body.gsub!(/\n/,"<br />")
#     @body = ReverseMarkdown.convert(@body)
#     if @body == ""
#       raise StandardError, "Empty email"
#     end
#   end
# 
# end

# test block for formatting html
# TODO: remove
# mail = 'spec/mocks/gmail-no-secret.eml'
# parse(mail)







# TESTING BLOCK

path = 'spec/mocks/'
device = 'gmail/'
# mail1 = JekyllEmail.new( path + device + 'no-subject.eml' )
# mail2 = JekyllEmail.new( path + device + 'empty.eml' )
# mail3 = JekyllEmail.new( path + device + 'no-secret.eml' )
# mail4 = JekyllEmail.new( path + device + 'wrong-secret.eml' )
mail5 = JekyllEmail.new( path + device + 'attached-inline.eml' )
# mail6 = JekyllEmail.new( path + device + 'attached-text.eml' )
# mail7 = JekyllEmail.new( path + device + 'attached-no-text.eml' )
# mail8 = JekyllEmail.new( path + device + 'inline.eml' )
# mail9 = JekyllEmail.new( path + device + 'emoji.eml' )
# mail10 = JekyllEmail.new( path + device + 'html-format.eml' )
# mail11 = JekyllEmail.new( path + device + 'html-no-format.eml' )
# mail12 = JekyllEmail.new( path + device + 'plain-text.eml' )
# mail10,mail11,mail12 = "nope"


# DEMO OF CONTINUING LOOP AFTER EXCEPTIONS - use for outputting subject, body, etc.
# ary = [mail1,mail2,mail3,mail4,mail5,mail6,mail7,mail8,mail9,mail10,mail11,mail12]
# ary = [mail2]
# ary.each do |item|
#   begin
#     # item.v_sub
#     # item.v_sec
#     item.v_bod
#   rescue
#     next
#   end
# end