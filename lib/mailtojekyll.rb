#!/usr/bin/env ruby

# TODO: git commits after sending


require_relative "mailtojekyll/version"
require 'mail'
require 'fileutils'
require 'optparse'
require 'highline/import'
require_relative 'jekyllemail'
require_relative 'jekyllpost'

module Mailtojekyll
  
  options = {}

  parser = OptionParser.new do|opts|
  	opts.banner = "Usage: mailtojekyll.rb [options]"
    
    opts.on('-r', '--repo repo', 'Repo') do |repo|
      options[:repo] = repo;
    end
    
  	opts.on('-s', '--server server', 'Server') do |server|
  		options[:server] = server;
  	end

  	opts.on('-u', '--user user', 'User') do |user|
  		options[:user] = user;
  	end
    
    opts.on('-p', '--pass pass', 'Pass') do |pass|
      options[:pass] = pass;
    end
    
    opts.on('-S', '--secret secret', 'Secret') do |secret|
      options[:secret] = secret;
    end
    
    opts.on('-I', '--imgdir imgdir', 'Imgdir') do |imgdir|
      options[:imgdir] = imgdir;
    end
    
    opts.on('-P', '--postdir postdir', 'Postdir') do |postdir|
      options[:postdir] = postdir;
    end
    
    opts.on('-l', '--layout layout', 'Layout') do |layout|
      options[:layout] = layout;
    end
    
    opts.on('-c', '--categories categories', 'Categories') do |categories|
      options[:categories] = categories;
    end

  	opts.on('-h', '--help', 'Displays Help') do
  		puts opts
  		exit
  	end
  end

  parser.parse!

  if options[:repo] == nil
  	puts 'Enter the location of your jekyll repo (e.g. /home/user/blog): '
      options[:repo] = gets.chomp
  end

  if options[:server] == nil
  	puts 'Enter your pop account server (e.g. pop.gmail.com): '
      options[:server] = gets.chomp
  end

  if options[:user] == nil
  	puts 'Enter your pop account username (e.g. xxxxx@gmail.com): '
      options[:user] = gets.chomp
  end

  if options[:pass] == nil
    options[:pass] = ask("Enter your pop account password:\n") { |q| q.echo="*" }
  end

  if options[:secret] == nil
  	puts 'Enter your mailtojekyll secret: '
      options[:secret] = gets.chomp
  end

  if options[:imgdir] == nil
  	puts 'Enter the location of your image directory (default: images): '
      options[:imgdir] = gets.chomp
  end

  if options[:postdir] == nil
  	puts 'Enter the location of your image directory (default: _posts): '
      options[:postdir] = gets.chomp
  end

  if options[:layout] == nil
  	puts 'Enter the jekyll template layout you want applied to these posts (default: post): '
      options[:layout] = gets.chomp
  end

  if options[:categories] == nil
  	puts 'Enter the jekyll categories you want applied to these posts, separated by commas (default: latest): '
      options[:categories] = gets.chomp
  end
  
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
  
  # empties, initializers & setup
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
