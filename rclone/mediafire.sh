#!/bin/bash
mediafire() {
  if [ -n $1 ]
  then
    echo $1 > mediafire.txt
    curl https://raw.githubusercontent.com/paperbenni/rclone/master/mediafiredownload.sh > mediafiredownload.sh
    chmod +x mediafiredownload.sh
    ./mediafiredownload.sh mediafire.txt
    rm mediafire.txt
    rm mediafiredownload.sh
  else
    echo "usage: mediafire [mediafire-link]"
  fi
}
