#!/usr/bin/env ruby

require 'nokogiri'
require 'reverse_markdown'

module ProcessPost
  
  def replace_images(post, atts, imgdir)
    atts.each do |img,vals|
      srchimg = "cid:" + vals[:cid].to_s
      post.gsub!(srchimg,"/#{imgdir}/#{vals[:fn]}")
      if vals[:cid] == ""
        newimg = "![](/#{imgdir}/#{vals[:fn]})\n\n"
        post << newimg
      end
    end
    post
  end
  
  def make_slug(title,time)
    title = title.downcase.gsub(/\W+/, ' ')
    title = title.split(" ").join("-")
    title += ".md"
    path = "#{time}-#{title}"
  end
  
  def create_imgdir(repo,imgdir)
    
    fullpath = "#{repo}/#{imgdir}"
    
    unless Dir.exists?(fullpath)
      puts "creating directory"
      FileUtils.mkdir_p(fullpath)
    else
      puts "today's images directory already exists"
    end
  end
  
end