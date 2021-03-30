#!/bin/sh

if [ ! -f podcast.rss ] || test "`find podcast.rss -mmin +8440`"; then
    wget --no-use-server-timestamps -O podcast.rss https://ilovelearningchinese.com/feed/podcast 
else
    echo "too new"
fi

#xmllint --xpath "//channel/item/*[self::link or self::title]" podcast.rss | xargs -L2 echo
xmllint --xpath "//channel/item/link/text()" podcast.rss > episodes.txt
          
