#!/usr/bin/env ruby

require 'fileutils'

module BlogSetup
  
  def create_dirs(images,posts)
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
  
end