#!/usr/bin/env ruby

class JekyllPost
  
  attr_reader :path, :post
  
  def initialize(title,body,atts)
    @date = Time.now
    @title = title
    # NEED TO PROCESS THESE TOGTHER TO OUTPUT @BODY
    @post = body
    @atts = atts
    @path = ""
  end
  
  def replace_images
    @atts.each do |fn,cid|
      srchimg = "cid:" + cid
      @post.gsub!(srchimg,fn)
      if cid == ""
        newimg = "![](" + fn + ")\n\n"
        @post << newimg
      end
    end
  end
  
  def make_slug    
    timepath = "/" + Time.now.year.to_s + "/" + Time.now.month.to_s.rjust(2,'0') + "/" + Time.now.day.to_s.rjust(2,'0') + "/"
    slug = @title.downcase.gsub(/\W+/, ' ')
    slug = slug.split(" ").join("-")
    slugpath = slug + ".md"
    @path = timepath + slugpath
  end
    
end