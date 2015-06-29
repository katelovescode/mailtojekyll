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

    opts.on('-t','--test') do |params|
      options[:retrieve] = "file"
    end

    # opts.on('-r', '--repo repo', 'Repo') do |repo|
    #   options[:jekyll_repo] = repo;
    # end
    # 
  	# opts.on('-s', '--server server', 'Server') do |server|
  	# 	options[:pop_server] = server;
  	# end
    # 
  	# opts.on('-u', '--user user', 'User') do |user|
  	# 	options[:pop_user] = user;
  	# end
    # 
    # opts.on('-p', '--pass pass', 'Pass') do |pass|
    #   options[:pop_password] = pass;
    # end
    # 
    # opts.on('-S', '--secret secret', 'Secret') do |secret|
    #   options[:secret] = secret;
    # end
    # 
    # opts.on('-I', '--imgdir imgdir', 'Imgdir') do |imgdir|
    #   options[:images_dir] = imgdir;
    # end
    # 
    # opts.on('-P', '--postdir postdir', 'Postdir') do |postdir|
    #   options[:posts_dir] = postdir;
    # end
    # 
    # opts.on('-l', '--layout layout', 'Layout') do |layout|
    #   options[:layout] = layout;
    # end
    # 
    # opts.on('-c', '--categories categories', 'Categories') do |categories|
    #   options[:categories] = categories;
    # end

  	opts.on('-h', '--help', 'Displays Help') do
  		puts opts
  		exit
  	end
  end

  parser.parse!

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
  config = YAML::load(File.open('_config.yml'))

  config['retrieve'] = 'pop'

  #TODO: If retrieve method is file - don't even set pop values

  config.each_pair do |k,v|
    if options[k.to_sym].nil? || options[k.to_sym].empty?
      options[k.to_sym] = config[k]
      #TODO: LOG THIS 
      print "Using config option for #{k}: "
    else
      # TODO: LOG THIS 
      print "Manually set option for #{k}: "
    end
    # TODO: LOG THIS 
    print "#{options[k.to_sym]}\n"
  end
  
  # empties, initializers & setup
  create_dirs("#{options[:jekyll_repo]}/#{options[:images_dir]}","#{options[:jekyll_repo]}/#{options[:posts_dir]}")
  meta = { layout: options[:layout], categories: options[:categories] }

  # get files or emails from pop server
  if options[:retrieve] == "file"
    Mail.defaults do
      retriever_method :test
    end
    Dir["#{config['test_source']}/*.eml"].each do |mail|
      Mail::TestRetriever.emails << Mail.read(mail)
    end
  elsif options[:retrieve] == "pop"
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
