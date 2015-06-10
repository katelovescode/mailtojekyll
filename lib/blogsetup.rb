#!/usr/bin/ruby

require 'fileutils'

module BlogSetup
  
  def create_dirs(images,posts)
    unless Dir.exists?(images)
      puts "creating directory"
      FileUtils.mkdir_p(images)
    else
      puts images
      puts "images directory already exists"
    end
    unless Dir.exists?(posts)
      puts "creating directory"
      FileUtils.mkdir_p(posts)
    else
      puts posts
      puts "posts directory already exists"
    end
  end
  
end