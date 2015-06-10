#!/usr/bin/ruby

require 'nokogiri'
require 'reverse_markdown'

module ProcessPost
  
  def replace_images(post, atts, imgdir)
    atts.each do |fn,cid|
      srchimg = "cid:" + cid
      post.gsub!(srchimg,"/#{imgdir}/#{fn}")
      if cid == ""
        newimg = "![](/#{imgdir}/#{fn})\n\n"
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
  
end