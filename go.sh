#!/bin/sh

if [ ! -f podcast.rss ] || test "`find podcast.rss -mmin +8440`"; then
    wget --no-use-server-timestamps -O podcast.rss https://ilovelearningchinese.com/feed/podcast 
else
    echo "too new"
fi

#xmllint --xpath "//channel/item/*[self::link or self::title]" podcast.rss | xargs -L2 echo
if [ ! -f episodes.txt ]; then
    xmllint --xpath "//channel/item/link/text()" podcast.rss > episodes.txt
fi

while read EPISODE_URL; do
    echo Processing $EPISODE_URL
    EPISODE_NUMBER=`echo $EPISODE_URL | cut -d "/" -f 5`
    echo Episode number $EPISODE_NUMBER
    if [ ! -d episodes/$EPISODE_NUMBER ]; then
        echo I should create the folder episodes/$EPISODE_NUMBER
        mkdir episodes/$EPISODE_NUMBER
        wget -P episodes/$EPISODE_NUMBER $EPISODE_URL
        mv episodes/$EPISODE_NUMBER/$EPISODE_NUMBER episodes/$EPISODE_NUMBER/index.html
    fi
    if [ ! -f episodes/$EPISODE_NUMBER/audio.txt ]; then
        grep -ohP https\?://\[\\w./\]+.mp3 episodes/$EPISODE_NUMBER/index.html | sort | uniq > episodes/$EPISODE_NUMBER/audio.txt
        wget -P episodes/$EPISODE_NUMBER -i episodes/$EPISODE_NUMBER/audio.txt
    fi

done < episodes.txt
          
