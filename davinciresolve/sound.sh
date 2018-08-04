#!/bin/bash
batchwav(){
  SOUNDTYPE="mp3"
  if [ -n $2 ]
  then
    SOUNDTYPE="$2"
  fi
  for filename in ./*."$2"
  do
    echo $filename
    if [ -e wav ]
    then
      echo "wav exists"
    else
      mkdir wav
    fi

    if ffprobe $1
    then
      ffmpeg -i "$filename" "wav/${filename%mp3}$SOUNDTYPE" 
    else
      echo "filetype not supported"
    fi
  done
}
