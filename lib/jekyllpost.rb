#!/usr/bin/env ruby

class JekyllPost

  def initialize(title, body, atts, repo, imgdir, pstdir, config)
    time = Time.now
    postday = time.strftime("%Y-%m-%d")
    posttime = time.strftime("%H:%M:%S")
    daydir = time.strftime("%Y/%m/%d")
    imgdir = "#{imgdir}/#{daydir}"
    path = make_slug(title,postday)
    post_filename = "#{repo}/#{pstdir}/#{path}"
    
    content = replace_images(body, atts, imgdir)
    create_imgdir(repo,imgdir)
    save_attachments(repo, imgdir, atts)
    create_post(post_filename, config, title, postday, posttime, atts, imgdir, content)
  end
  
  def create_post(post_filename, config, title, postday, posttime, atts, imgdir, content)
    open(post_filename, 'w') do |post|
      post << "---\n"
      post << "layout: #{config[:layout]}\n"
      post << "title: #{title}\n"
      post << "date: #{postday} #{posttime}\n"
      post << "categories: #{config[:categories]}\n"
      unless atts.empty?
        key,val = atts[:image0][:filename]
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
        filename = att[:filename]
        begin
          File.open("#{repo}/#{imgdir}/#{filename}", "w+b", 0644) {|f| f.write att[:content]}
        rescue => e
          puts "Unable to save data for #{filename} because #{e.message}"
        end
      end
    end
  end  
  
  def replace_images(post, atts, imgdir)
    atts.each do |img,vals|
      srchimg = "![](#{vals[:filename]})"
      unless post.nil?
        post.gsub!(srchimg,"/#{imgdir}/#{vals[:filename]}")
        # if vals[:cid] == ""
        #   newimg = "![](/#{imgdir}/#{vals[:filename]})\n\n"
        #   post << newimg
        # end
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
      # TODO: LOG THIS puts "creating directory"
      FileUtils.mkdir_p(fullpath)
    else
      # TODO: LOG THIS puts "today's images directory already exists"
    end
  end
  
end