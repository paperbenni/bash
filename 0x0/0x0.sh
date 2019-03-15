#!/usr/bin/env bash

0x0(){
  ls "$1" > /dev/null || (echo "file not found" && return)
  curl -# -F "file=@$1" "https://0x0.st"
}
