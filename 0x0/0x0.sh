#!/usr/bin/env bash

# uploads a file to 0x0, functions similar to transfer.sh
0x0() {
    ls "$1" >/dev/null || (echo "file not found" && return)
    curl -# -F "file=@$1" "https://0x0.st"
}
