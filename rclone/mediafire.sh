#!/bin/bash
mediafire() {
  if [ -n $1 ]
  then
    echo $1 > mediafire.txt
    ~/.paperbenni/rclone/mediafire/mediafire.sh mediafire.txt
    rm mediafire.txt
    rm mediafiredownload.sh
  else
    echo "usage: mediafire [mediafire-link]"
  fi
}
