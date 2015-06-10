#!/usr/bin/env ruby

require_relative "processpost"

class JekyllPost
  
  include ProcessPost
  
  attr_reader :path, :content
  
  def initialize(title, body, atts, repo, imgdir, pstdir, config)
    time = "#{Time.now.year.to_s}-#{Time.now.month.to_s.rjust(2,'0')}-#{Time.now.day.to_s.rjust(2,'0')}"
    
    daydir = time.split("-").join("/")
    imgdir = "#{imgdir}/#{daydir}"
    
    @content = replace_images(body, atts, imgdir)
    @path = make_slug(title,time)
    create_imgdir(repo,imgdir)

    postfn = "#{repo}/#{pstdir}/#{@path}"
    
    open(postfn, 'w') do |post|
      post << "---\n"
      post << "layout: #{config[:layout]}\n"
      post << "title: #{title}\n"
      post << "date: #{time}\n"
      post << "categories: #{config[:categories]}\n"
      unless atts.empty?
        key,val = atts[:image0][:fn]
        post << "image: /#{imgdir}/#{key}\n"
      end
      post << "---\n"
      post << "#{@content}"
    end
    
    atts.each do |img,att|
      if (att[:type].start_with?('image/'))
        # extracting images for example...
        filename = att[:fn]
        begin
          File.open("#{repo}/#{imgdir}/#{filename}", "w+b", 0644) {|f| f.write att[:cont]}
        rescue => e
          puts "Unable to save data for #{filename} because #{e.message}"
        end
      end
    end
    

    
  end
  
end