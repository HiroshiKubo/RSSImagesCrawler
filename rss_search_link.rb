require 'open-uri'
require 'fastimage'
require 'json'
require 'date'
require 'fileutils'

require ('./download_image_lib.rb')

UserAgent = 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)'

def main()
  now_date = Date.today
  rss_version = 1
  
  content_date = nil  #記事の日時
  content_url  = nil  #コンテンツのURL

  json_data = nil
  json_file = open("./rss_data.json")
  json_data = JSON.parse(json_file.read)
  
  date_range = json_data["date_range"].to_i  #何日前までの記事をチェックするか
  path       = json_data["save_path"]        #画像を保存するPath

  urls = json_data["target_urls"]

  urls.each do |url|
    url = URI.encode(url)
    puts "URL"+url
    
    site_domain = url.to_s.match(/:\/\/[^\/]+/)
    site_domain = site_domain.to_s.slice!(3,site_domain.to_s.size-2)
    site_domain = site_domain.gsub(".","_")
    if Dir.glob(json_data["save_path"]+"/"+site_domain) == []
      FileUtils.mkdir_p(json_data["save_path"]+"/"+site_domain)
      path = json_data["save_path"]+"/"+site_domain
    end

    open(url, "User-Agent" => UserAgent) do |f|
      f.each_line do |line|
        rss_version = 2 if /<rss version="2.0">/ =~ line
          
        line = line.match( /<item rdf:about=.+|<dc:date>.+|<guid isPermaLink="true">.+|<pubDate>.+/)
        if line != nil

          array = line.to_s.split(/[();^]/)
          array.each do |cut|
            date = makeDate(cut.to_s,rss_version)
            
            if date != nil
              content_date = date
              
              if rss_version == 1
                downloadImage(content_url,path) if checkDate(now_date,content_date,date_range) == true
              end
              break
            end
            
            site_url = linkSearch(cut,rss_version)
            if site_url != nil
              content_url = site_url
              if rss_version == 2
                downloadImage(site_url,path) if checkDate(now_date,content_date,date_range) == true
              end
              break
            end
          end
        end
      end
    end
    rss_version = 1
  end
end

def linkSearch(command, rss_version)
  if rss_version == 1
    command = command.to_s.match(/<item rdf:about=.+/)
    if command != nil
      site_url = command.to_s.match(/".+"/)
      site_url = site_url.to_s.slice!(1, site_url.to_s.size-2)
      
      puts "link:"+site_url
      return site_url.to_s
    end
  else
    command = command.to_s.match(/<guid isPermaLink="true">.+<\/guid>/)
    if command != nil
      site_url = command.to_s.match(/\>.+\</)
      site_url = site_url.to_s.slice!(1, site_url.to_s.size-2)
      
      puts "link:"+site_url
      return site_url.to_s
    end
  end
  return nil
end


def makeDate(cut, rss_version)
  if rss_version == 1
    date = cut.to_s.match(/<dc:date>.+\/dc:date/)

    if date != nil
      date = date.to_s.match(/[0-9]{4}-[0-9]{2}-[0-9]{2}/)
      return date
    end
  else
    date = cut.to_s.match(/<pubDate>.+<\/pubDate>/)
    if date != nil
      date = date.to_s.match(/[A-Z][a-z]{2}, [0-9]{2} [A-Z][a-z]{2} [0-9]{4}/)
      date = Date.parse(date.to_s)
      date = date.strftime("%Y-%m-%d")
      return date
    end
  end
end

def checkDate(now_date, content_date, date_range)
  now_date = Date.parse(now_date.to_s)
  content_date = Date.parse(content_date.to_s)
  content_date += date_range

  if(now_date <= content_date)
    return true
  end
  return false
end

main()