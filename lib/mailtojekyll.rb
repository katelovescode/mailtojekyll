#!/usr/bin/env ruby

require 'mail'
require_relative 'jekyllemail'
require_relative 'jekyllpost'
require_relative 'blogsetup'

# get config
environment = 'development'
environment = ENV['APP_ENV'] unless ENV['APP_ENV'].nil?

yaml = YAML::load(File.open('_config.yml'))[environment]
blogs = yaml['blogs']

include BlogSetup

blogs.each do |blog|

  # empties, initializers & setup
  emails = []
  create_dirs("#{blog['jekyll_repo']}/#{blog['images_dir']}","#{blog['jekyll_repo']}/#{blog['posts_dir']}")
  config = { layout: blog['layout'], categories: blog['categories'] }
  
  # get files or emails from pop server
  if blog['retrieve'] == "file"
    emails = Dir["#{blog['source']}/*.eml"]
  elsif blog['retrieve'] == "pop"
    # set mail retrieval defaults for the Mail gem
    Mail.defaults do
      mail_settings = {
        address: blog['pop_server'],
        port: 995,
        user_name: blog['pop_user'],
        password: blog['pop_password'],
        enable_ssl: true
      }
      retriever_method :pop3, mail_settings
    end
    emails = Mail.all
  end
  
  # test for validity and create posts
  emails.each do |email|
  
    # make a new email
    email = JekyllEmail.new(email)
    
    # validity tests
    begin
      email.v_sub
      email.v_sec
      email.v_bod
    rescue
      next
    end

    post = JekyllPost.new(email.title, email.body, email.atts, blog['jekyll_repo'], blog['images_dir'], blog['posts_dir'], config)
    # for grabbing markdown in a more efficient/accurate way than copy-paste from the terminal
    # emails 
    # output = email.title + ".md"
    # File.open(output, 'w') { |file| file.write(email.body) }
    # posts
    # output = post.title + ".md"
    # File.open(output, 'w') { |file| file.write(post.post) }

  end

end

# loop through emails to create multiple Post objects (based on Post Class)
# each Post instantiates multiple Image objects (based on Image Class)
# ^-- may not be necessary?

# Post has: Title, Date, Body, Images, Markdown file (save location)
# Image has: Alt text (maybe), file (save location)

# KATE'S LIST
# TODO: Figure something out for mail signatures
# TODO: Save images to file

