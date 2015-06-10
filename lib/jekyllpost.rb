#!/usr/bin/env ruby

class JekyllPost
  
  attr_reader :date, :title, :body
  
  def initialize(title,body,atts)
    @date = Time.now
    @title = title
    @body = body
    @atts = atts
  
    puts @date
    puts @title
    puts @body
    puts @atts
  
  end
  
  
    
  
  # googlesrc = "cid:" + data[:cid]
  # node = body.xpath("//img[@src = '#{googlesrc}']").first
  # puts node
  # if !node.nil?
  #   node.set_attribute 'src', data[:path]
  #   node.xpath("//@width").remove
  #   node.xpath("//@height").remove
  # else
  #   # attach = Nokogiri::XML::Node.new "img", body
  #   # attach["src"] = data[:path]
  #   # attach["style"] = "float:none;clear:both;display:block;margin:auto;padding:10px;"
  #   # div = body.at_css "body"
  #   # puts div
  #   # attach.parent = div
  # end
  
end