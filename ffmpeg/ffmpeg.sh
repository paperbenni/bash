#!/bin/bash

pname ffmpeg/ffmpeg

sequencevideo() {
    if ls *.png &>/dev/null; then
        ffmpeg -framerate 30 -pattern_type glob -i '*'"${1:-.png}" \
            -c:v libx264 -pix_fmt yuv420p out.mp4
    elif ls *.jpg &>/dev/null; then
        ffmpeg -framerate 30 -pattern_type glob -i '*'"${1:-.png}" \
            -c:v libx264 -pix_fmt yuv420p out.mp4
    fi
}
