
c2r(){
  if ffprobe "$1"
  then
    if [ -e "${1%.*}.mov" ] || [ -e ./resolve/"${1%.*}.mov" ]
    then
      echo "skipping $1"
    else
      ffmpeg -y -i "$1" -c:v mpeg4 -r ntsc-film -b:v 250000k -c:a pcm_s16le "${1%.*}.mov"
      if [ -e ./resolve ]
      then
        mv "${1%.*}.mov" resolve/"${1%.*}.mov"
      fi
    fi
  fi
}

c2rtime(){
  SPEED=$(echo "1 / $2" | bc -l)
  echo "speed $SPEED"
  if ffprobe "$1"
  then
    if [ -e "${1%.*}.mov" ] || [ -e ./resolve/"${1%.*}.mov" ]
    then
      echo "skipping $1"
    else
      ffmpeg -y -i "$1" -c:v mpeg4 -r 60 -b:v 250000k -c:a pcm_s16le -filter:v "setpts=$SPEED*PTS" -an "${1%.*}.mov"
      if [ -e ./resolve ]
      then
        mv "${1%.*}.mov" resolve/"${1%.*}.mov"
      fi
    fi
  fi
}

batchc2r(){
for $file in ./*
do
  c2r $file
done
}
