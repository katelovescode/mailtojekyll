#!/usr/bin/env ruby

# TODO: git commits after sending


require_relative "mailtojekyll/version"
require 'mail'
require 'fileutils'
require_relative 'jekyllemail'
require_relative 'jekyllpost'

module Mailtojekyll
  
  def self.create_dirs(images,posts)
    unless Dir.exists?(images)
      # TODO: LOG THIS puts "creating directory"
      FileUtils.mkdir_p(images)
    else
      # TODO: LOG THIS puts images
      # TODO: LOG THIS puts "images directory already exists"
    end
    unless Dir.exists?(posts)
      # TODO: LOG THIS puts "creating directory"
      FileUtils.mkdir_p(posts)
    else
      # TODO: LOG THIS puts posts
      # TODO: LOG THIS puts "posts directory already exists"
    end
  end

  # get config
  environment = 'development'
  environment = ENV['APP_ENV'] unless ENV['APP_ENV'].nil?
  
  config = YAML::load(File.open('_config.yml'))[environment]
  puts config['jekyll_repo']
  
  # empties, initializers & setup
  emails = []
  create_dirs("#{config['jekyll_repo']}/#{config['images_dir']}","#{config['jekyll_repo']}/#{config['posts_dir']}")
  meta = { layout: config['layout'], categories: config['categories'] }
  
  # get files or emails from pop server
  if config['retrieve'] == "file"
    Mail.defaults do
      retriever_method :test
    end
    Dir["#{config['source']}/*.eml"].each do |mail|
      Mail::TestRetriever.emails << Mail.read(mail)
    end
  elsif config['retrieve'] == "pop"
    # set mail retrieval defaults for the Mail gem
    Mail.defaults do
      mail_settings = {
        address: config['pop_server'],
        port: 995,
        user_name: config['pop_user'],
        password: config['pop_password'],
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
    
    post = JekyllPost.new(email.title, email.body, email.atts, config['jekyll_repo'], config['images_dir'], config['posts_dir'], meta)

  end
  

  
end
