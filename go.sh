#!/bin/sh

if [ ! -f podcast.rss ] || test "`find podcast.rss -mmin +1440`"; then
    wget --no-use-server-timestamps -O podcast.rss https://ilovelearningchinese.com/feed/podcast 
else
    echo "too new"
fi

xmllint --xpath "//channel/item/*[self::link or self::title]" podcast.rss

          
