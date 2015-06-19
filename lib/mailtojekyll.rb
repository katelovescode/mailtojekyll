#!/usr/bin/env ruby

# TODO: git commits after sending
# TODO: which config options should be command-line accessible?

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
      options[:jekyll_repo] = repo;
    end
    
  	opts.on('-s', '--server server', 'Server') do |server|
  		options[:pop_server] = server;
  	end

  	opts.on('-u', '--user user', 'User') do |user|
  		options[:pop_user] = user;
  	end
    
    opts.on('-p', '--pass pass', 'Pass') do |pass|
      options[:pop_password] = pass;
    end
    
    opts.on('-S', '--secret secret', 'Secret') do |secret|
      options[:secret] = secret;
    end
    
    opts.on('-I', '--imgdir imgdir', 'Imgdir') do |imgdir|
      options[:images_dir] = imgdir;
    end
    
    opts.on('-P', '--postdir postdir', 'Postdir') do |postdir|
      options[:posts_dir] = postdir;
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

  if options[:jekyll_repo] == nil
  	print 'Path to jekyll repo: '
      options[:jekyll_repo] = gets.chomp
  end

  if options[:pop_server] == nil
  	print 'POP account server: '
      options[:pop_server] = gets.chomp
  end

  if options[:pop_user] == nil
  	print 'POP account username: '
      options[:pop_user] = gets.chomp
  end

  if options[:pop_password] == nil
    options[:pop_password] = ask("POP account password: ") { |q| q.echo="*" }
  end

  if options[:secret] == nil
  	print 'Subject line secret: '
      options[:secret] = gets.chomp
  end

  if options[:images_dir] == nil
  	print 'Relative path to image directory: '
      options[:images_dir] = gets.chomp
  end

  if options[:posts_dir] == nil
  	print 'Relative path to image directory: '
      options[:posts_dir] = gets.chomp
  end

  if options[:layout] == nil
  	print 'Template layout: '
      options[:layout] = gets.chomp
  end

  if options[:categories] == nil
  	print 'Categories, separated by commas: '
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
  
  options.each_pair do |k,v|
    if v.empty?
      options[k] = config["#{k}"]
      puts "Using default value for #{k}: #{options[k]}"
    end
  end
  
  # empties, initializers & setup
  create_dirs("#{options[:jekyll_repo]}/#{options[:images_dir]}","#{options[:jekyll_repo]}/#{options[:posts_dir]}")
  meta = { layout: options[:layout], categories: options[:categories] }
  
  # get files or emails from pop server
  if config['retrieve'] == "file"
    Mail.defaults do
      retriever_method :test
    end
    Dir["#{config['test_source']}/*.eml"].each do |mail|
      Mail::TestRetriever.emails << Mail.read(mail)
    end
  elsif config['retrieve'] == "pop"
    # set mail retrieval defaults for the Mail gem
    Mail.defaults do
      mail_settings = {
        address: options[:pop_server],
        port: 995,
        user_name: options[:pop_user],
        password: options[:pop_password],
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
    
    post = JekyllPost.new(email.title, email.body, email.atts, options[:jekyll_repo], options[:images_dir], options[:posts_dir], meta)

  end
  

  
end
