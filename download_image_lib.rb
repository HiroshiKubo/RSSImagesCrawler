require 'open-uri'
require 'fastimage'

def downloadImage(url,path)
  url = "http://"+url.to_s unless /http:\/\/|https:\/\// =~ url.to_s
  url = URI.encode(url)
  
  #puts "保存先を入力してください(fullPathがおすすめです)"
  path = path.split("\n")[0]
  path += "/" if path[path.size-1] != "/"

  siteDomain = url
  siteDomain = siteDomain.scan(/http:\/\/[^\/]+\/|https:\/\/[^\/]+\//)[0].to_s
  open(url, "User-Agent" => UserAgent) do |f|
    f.each_line do |line|
      line = line.match( /.+(jpeg|jpg|png|gif).+"/ )
      if line != nil
        array = line.to_s.split(/[ ()<>;,]/)

        array.each do |cut|
          image_url = cut.to_s.match(/".+(\.jpeg|\.jpg|\.png|\.gif).*"/)
          image_url = image_url.to_s
          image_url = image_url.slice!(1,image_url.to_s.size-2)
          
          if image_url != nil
            
            puts image_url
            #間接参照での画像のURLの場合はサイトのドメインを追加
            image_url = siteDomain.to_s+image_url if /http./ !~ image_url
            #URLがunicodeの場合はエンコードする
            cut = URI.unescape(image_url) if /.+%3a%2f%2f+./ =~ image_url

            fileName = image_url.split("/")
            fileName = fileName[fileName.size-1]
            saveData(path,fileName,image_url);
          end
        end
      end
    end
  end
end

def saveData(path,fileName,url)
  if /jpg|png|jpeg|gif/ =~ url
    img_size = FastImage.size(url)  #[0]:横 [1]:縦
    return nil if img_size == nil
    return nil if 300 > img_size[0]
    return nil if 300 > img_size[1]
  end 
  
  open(path+fileName, 'wb') do |saved_file|
    open(url, 'rb') do |read_file|
      saved_file.write(read_file.read)
    end
  end
end
