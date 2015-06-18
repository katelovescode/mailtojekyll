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
    Mail.defaults do
      retriever_method :test
    end
    Dir["#{blog['source']}/*.eml"].each do |mail|
      Mail::TestRetriever.emails << Mail.read(mail)
    end
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
  end

  emails = Mail.all

  # test for validity and create posts
  emails.each do |email|
  
    # make a new email
    email = JekyllEmail.new(email)
    
    # validity tests
    begin
      email.validate_subject
      email.validate_secret
      email.validate_body
    rescue
      next
    end
    
    post = JekyllPost.new(email.title, email.body, email.atts, blog['jekyll_repo'], blog['images_dir'], blog['posts_dir'], config)

  end

end