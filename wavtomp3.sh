#!/bin/bash

for filename in ./*.mp3
do
echo $filename
if [ -e wav ]
then
echo "wav exists"
else
mkdir wav
fi

ffmpeg -i "$filename" "wav/${filename%mp3}wav" 

done
