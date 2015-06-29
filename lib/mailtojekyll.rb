#!/usr/bin/env ruby

# TODO: git commits after sending

require_relative "mailtojekyll/version"
require 'mail'
require 'fileutils'
require 'optparse'
require 'highline/import'
require 'git'
require 'logger'
require_relative 'jekyllemail'
require_relative 'jekyllpost'

module Mailtojekyll
  
  options = {}

  # allow a test flag to be set to retrieve files from a server directory rather than a pop account
  parser = OptionParser.new do|opts|
  	opts.banner = "Usage: mailtojekyll.rb [options]"

    opts.on('-t','--test', 'Turns on the test flag, retrieves .eml files from test_source directory in config file') do |params|
      options[:retrieve] = "file"
    end

  	opts.on('-h', '--help', 'Displays Help') do
  		puts opts
  		exit
  	end
  end

  parser.parse!

  # create image and post directories if they don't exist
  def self.create_dirs(images,posts)
    unless Dir.exists?(images)
      FileUtils.mkdir_p(images)
    end
    unless Dir.exists?(posts)
      FileUtils.mkdir_p(posts)
    end
  end

  # get config
  config = YAML::load(File.open('_config.yml'))

  # default to pop method unless test is set by flag
  config['retrieve'] = 'pop'

  config.each_pair do |k,v|
    if options[k.to_sym].nil? || options[k.to_sym].empty?
      options[k.to_sym] = config[k]
      #TODO: LOG THIS print "Using config option for #{k}: "
    else
      # TODO: LOG THIS print "Manually set option for #{k}: "
    end
    # TODO: LOG THIS print "#{options[k.to_sym]}\n"
  end
  
  # open the repo and checkout the content branch
  testrepo = Git.open(options[:jekyll_repo])
  testrepo.add_remote('origin',options[:remote_repo]) unless testrepo.remote.url == options[:remote_repo]
  testrepo.branch('content').checkout
  testrepo.pull('origin','content') if testrepo.branches.remote.include?("content")
  
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
    # set pop retrieval defaults for the Mail gem
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
  
  if emails.empty?
    puts "No new mails to process via #{options[:retrieve]} method" 
    exit
  else
    puts "Fetching mails via #{options[:retrieve]} method"
  end

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
    
    # make a new post
    post = JekyllPost.new(email.title, email.body, email.atts, options[:jekyll_repo], options[:images_dir], options[:posts_dir], meta)
    
  end
  
  # commit the changes to the repo and push
  unless testrepo.diff.size == 0
    testrepo.add(:all=>true)
    testrepo.commit("Adding email post(s) from #{Time.now}")
  end
  testrepo.push('origin','content')
  testrepo.branch("develop").checkout
  testrepo.pull('origin','develop') if testrepo.branches.remote.include?("develop")
  testrepo.branch("develop").merge("content")
  testrepo.push('origin','develop')
  testrepo.branch("master").checkout
  testrepo.pull('origin','master') if testrepo.branches.remote.include?("master")
  testrepo.branch("master").merge("develop")
  testrepo.push
  testrepo.branch("content").checkout
end
