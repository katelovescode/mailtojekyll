#!/usr/bin/env ruby

class JekyllPost

  def initialize(title, body, atts, repo, imgdir, pstdir, config)
    time = Time.now
    postday = time.strftime("%Y-%m-%d")
    posttime = time.strftime("%H:%M:%S")
    daydir = time.strftime("%Y/%m/%d")
    imgdir = "#{imgdir}/#{daydir}"
    path = make_slug(title,postday)
    postfn = "#{repo}/#{pstdir}/#{path}"
    
    content = replace_images(body, atts, imgdir)
    create_imgdir(repo,imgdir)
    save_attachments(repo, imgdir, atts)
    create_post(postfn, config, title, postday, posttime, atts, imgdir, content)
  end
  
  def create_post(postfn, config, title, postday, posttime, atts, imgdir, content)
    open(postfn, 'w') do |post|
      post << "---\n"
      post << "layout: #{config[:layout]}\n"
      post << "title: #{title}\n"
      post << "date: #{postday} #{posttime}\n"
      post << "categories: #{config[:categories]}\n"
      unless atts.empty?
        key,val = atts[:image0][:fn]
        post << "image: /#{imgdir}/#{key}\n"
      end
      post << "---\n"
      post << "#{content}"
    end
  end
  
  def save_attachments(repo, imgdir, atts)
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