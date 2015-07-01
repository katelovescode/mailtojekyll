#!/usr/bin/env ruby

require_relative "mailtojekyll/version"
require 'mail'
require 'fileutils'
require 'optparse'
require 'logger'
require_relative 'jekyllemail'
require_relative 'jekyllpost'

module Mailtojekyll
  
  # create image and post directories if they don't exist
  def self.create_dirs(images,posts)
    unless Dir.exists?(images)
      FileUtils.mkdir_p(images)
    end
    unless Dir.exists?(posts)
      FileUtils.mkdir_p(posts)
    end
  end
  
  # empties and initializers
  home = Dir.pwd
  options = {jekyll_repo: nil, retrieve: nil, test_source: nil, pop_server: nil, pop_user: nil, pop_password: nil, secret: nil, images_dir: nil, posts_dir: nil, layout: nil, categories: nil, deploy_repo: nil, origin_repo: nil}

  # command line options for cron job settings
  parser = OptionParser.new do|opts|
  	opts.banner = "\nRequired flags are marked with an asterisk(*)\n\nUsage: mailtojekyll.rb [options]\n\n\n"
    
    opts.on('-t','--test path/to/emails', "Retrieves saved emails from this directory (path is relative to your gem installation root)\n\t\t\t\t     When using the test flag, the POP flags are not required\n\n") do |param|
      options[:retrieve] = "file"
      options[:test_source] = param
    end

    opts.on('-j','--jekyll path/to/repo', '*Local absolute path to the git repo for your jekyll installation') do |param|
      options[:jekyll_repo] = param
    end
    
    opts.on('-s','--server pop.example.com', '*POP server for mail retrieval') do |param|
      options[:pop_server] = param
    end
    
    opts.on('-u','--user example@example.com', '*POP username (may be a full email address)') do |param|
      options[:pop_user] = param
    end
    
    opts.on('-p','--pass examplepassword', '*POP password') do |param|
      options[:pop_password] = param
    end
    
    opts.on('-S','--secret secretword', '*Secret word mailtojekyll should look for in the subject line') do |param|
      options[:secret] = param
    end
    
    opts.on('-i','--imgdir path/to/imgs', '*Image directory (path is relative to your jekyll repo root)') do |param|
      options[:images_dir] = param
    end
    
    opts.on('-P','--postdir path/to/posts', '*Posts directory (path is relative to your jekyll repo root)') do |param|
      options[:posts_dir] = param
    end
    
    opts.on('-d','--deploy path/to/remote', "*Deployment remote repo URL") do |param|
      options[:deploy_repo] = param
    end

    opts.on('-o','--origin path/to/remote', "*Origin remote repo URL\n\n") do |param|
      options[:origin_repo] = param
    end


    opts.on('-l','--layout layout', 'Jekyll template layout (default is "post")') do |param|
      options[:layout] = param
    end

    opts.on('-c','--cats "cat 1, cat 2, cat 3"', 'Jekyll post categories (default is "latest")') do |param|
      options[:categories] = param.split(",")
    end

  	opts.on('-h', '--help', "Displays Help\n\n") do
  		puts opts
  		exit
  	end
  end
  
  ARGV.push('-h') if ARGV.empty?

  parser.parse!

  # default to pop method unless test is set by flag
  if options[:retrieve].to_s.empty?
    options[:retrieve] = "pop"
  end

  if options[:retrieve] == "pop"
    if options[:pop_server].to_s.empty? || options[:pop_user].to_s.empty? || options[:pop_password].to_s.empty?
      raise "All POP flags are required"
      exit
    end
  end

  options.each_pair do |k,v|
    if k == :layout && options[k].to_s.empty?
      options[k] = "post"
    elsif k == :categories && options[k].to_s.empty?
      options[k] = "latest"
    elsif k == :test_source && options[:retrieve] == "pop"
      next      
    else
      if options[k].to_s.empty?
        unless options[:retrieve] == "file" && (k == :pop_server || k == :pop_user || k == :pop_password)
          raise "#{k} flag is required"
          exit
        end
      end
    end
  end

  # get files or emails from pop server
  puts "Checking for emails..."
  if options[:retrieve] == "file"
    Mail.defaults do
      retriever_method :test
    end
    Dir["#{options[:test_source]}/*.eml"].each do |mail|
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
    puts "Setting up directories..."
    # empties, initializers & setup
    create_dirs("#{options[:jekyll_repo]}/#{options[:images_dir]}","#{options[:jekyll_repo]}/#{options[:posts_dir]}")
    meta = { layout: options[:layout], categories: options[:categories] }
    puts "Configuring git repositories..."
    # open the repo and checkout the content branch
    Dir.chdir(options[:jekyll_repo])
    findremotes = `git remote -v`
    unless findremotes.include?("deploy	#{options[:deploy_repo]} (push)")
      `git remote add deploy #{options[:deploy_repo]}`
    end
    unless findremotes.include?("origin	#{options[:origin_repo]} (push)")
      `git remote add origin #{options[:origin_repo]}`
    end
    findbranches = `git branch`
    `git checkout -b master` unless findbranches.include?("master")
    `git checkout master` unless findbranches.include?("* master")
    `git pull -q deploy master`
    nowbranch = "posts/#{Time.now.strftime("%Y%m%d%H%M%S")}"
    `git checkout -q -b #{nowbranch}`
    Dir.chdir(home)
    puts "Fetching mails via #{options[:retrieve]} method..."

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
      
      puts "Creating post..."
      # make a new post
      post = JekyllPost.new(email.title, email.body, email.atts, options[:jekyll_repo], options[:images_dir], options[:posts_dir], meta)
      
    end
    
    # commit the changes to the repo and push
    puts "Updating git repositories..."
    Dir.chdir(options[:jekyll_repo])
    `git add -A && git commit -m "mailtojekyll: Adding email posts from #{Time.now}"`
    `git checkout -q master && git merge -q #{nowbranch} && git branch -q -d #{nowbranch}`
    `git push -q deploy master && git push -q origin master`
    Dir.chdir(home)
    puts "Finished!"
  end
end
