#!/usr/bin/env bash
#extract text from images

pname ocr/ocr

ocr() {
    if command -v tesseract && [ -e "$1" ]; then
        convert -colorspace gray -fill white -resize 480% -sharpen 0x1 "$1" "tes$1" || return 1
        tesseract "tes$1" "${1%.*}"
    else
        echo "usage: ocr file"
    fi
}
