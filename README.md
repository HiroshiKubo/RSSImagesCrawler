RSSImageCrawer
====

rss_data.jsonに登録したRSSの画像をダウンロードするCrawerっぽいもの

##Description

前もってrss_data.jsonに確認したいサイトのRSSとダウンロードした画像の保存先のパスを記載します。
rss_search_link.rbを起動すると、記載したRSSの記事の先にある画像(width:400px height:400px以上)を保存先のパスにドメインごとに保存します。

##Requirement

rubyのfastimageが必要です。

##Usage
rss_data.jsonの中身は以下のようになっています。
{	"date_range" : 0,
	"save_path"  : "/Users/UserName/Pictures/",
	"rss_data"   :{	
		"0":"http://www.saiani.net/feed",
		"1":"http://otanews.livedoor.biz/index.rdf",
		"2":"http://ponpokonwes.blog.jp/index.rdf"
	}
}
date_range : 何日前の記事を取得するかを記載（本日のみの場合は、0を記述）
save_path  : ダウンロードした画像を保存するパスを記載。パスの先にサイトごとのディレクトリを作成し、保存する
rss_data   : RSSのデータの配列です。左側は文字列で"0","1","2"と増やし、右側にURLを記載してください