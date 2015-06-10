#!/usr/bin/env ruby

require_relative "processpost"

class JekyllPost
  
  include ProcessPost
  
  attr_reader :path, :content
  
  def initialize(title, body, atts, repo, imgdir, pstdir, config)
    time = "#{Time.now.year.to_s}-#{Time.now.month.to_s.rjust(2,'0')}-#{Time.now.day.to_s.rjust(2,'0')}"
    @content = replace_images(body, atts, imgdir)
    @path = make_slug(title,time)

    postfn = "#{repo}/#{pstdir}/#{@path}"
    
    open(postfn, 'w') do |post|
      post << "---\n"
      post << "layout: #{config[:layout]}\n"
      post << "title: #{title}\n"
      post << "date: #{time}\n"
      post << "categories: #{config[:categories]}\n"
      unless atts.empty?
        key,val = atts.first
        post << "image: /#{imgdir}/#{key}\n"
      end
      post << "---\n"
      post << "#{@content}"
    end
    
  end
  
end