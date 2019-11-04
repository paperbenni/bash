#!/usr/bin/env bash

pname wget/curl

getlinks() {
    echo "$1"
    curl -s "$1" |
        grep -o '<a href=".*">.*</a>' |
        grep -o '".*"' | grep -E -o '[^"]*' |
        urldecode
}
