#!/bin/bash
pname image/image
visbpng() {
    convert -size 1920x1080 xc:transparent -gravity Center \
        -font Visby-Round-CF-Medium -weight 800 -pointsize 100 -annotate 0 "$1" "$2"
}
