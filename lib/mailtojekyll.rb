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





# TESTING BLOCK

device = 'lgmail/'

filearray = [
  # "no-subject.eml",
  # "empty.eml",
  # "no-secret.eml",
  # "wrong-secret.eml",
  # "attached-inline.eml",
  # "attached-text.eml",
  # "attached-no-text.eml",
  # "inline.eml",
  "emoji.eml",
  # "html-format.eml",
  # "html-no-format.eml",
  # "plain-text.eml"
]

filearray.map! { |x| 'spec/mocks/' + device + x }

h = {}

filearray.each_with_index do |x, idx|
  ind = "mail" + idx.to_s
  h[ind] = JekyllEmail.new(x)

  # puts h[ind].title
  puts h[ind].body

end

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