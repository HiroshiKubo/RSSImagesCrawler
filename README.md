RSSImageCrawler
====

rss_data.jsonに登録したRSSの画像をダウンロードするCrawlerっぽいもの  
正規表現とGitHubの勉強のため作成しました。  

##Description

前もってrss_data.jsonに確認したいサイトのRSSとダウンロードした画像の保存先のパスを記載します。  
rss_search_link.rbを起動すると、記載したRSSの記事の先にある画像(width:400px height:400px以上)  を保存先のパスにドメインごとに保存します。  

##Requirement

rubyのfastimageが必要です。

##Usage
rss_data.jsonの中身は以下のようになっています。  
{	"date_range" : 0,  
	"save_path"  : "/Users/UserName/Pictures/",  
	"target_urls"   : ]  
		http://◯◯◯/feed",  
		"http://◯◯◯/index.rdf",  
		"http://◯◯◯/index.rdf"  
	]  
}  
date_range  : 何日前の記事を取得するかを記載（本日のみの場合は、0を記述）  
save_path   : ダウンロードした画像を保存するパスを記載。パスの先にサイトごとのディレクトリを作成し、保存する。  
target_urls : RSSのデータの配列です。URLを記載してください。  