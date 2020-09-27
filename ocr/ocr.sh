#!/usr/bin/env bash
#extract text from images

pname ocr/ocr

ocr() {
    if command -v tesseract &> /dev/null && [ -e "$1" ]; then
        convert -colorspace gray -fill white -resize 480% -sharpen 0x1 "$1" "tes$1" || return 1
        tesseract "tes$1" "${1%.*}" &> /dev/null
        cat "${1%.*}.txt"
        rm "${1%.*}.txt" "tes$1"
    else
        echo "usage: ocr file"
    fi
}
