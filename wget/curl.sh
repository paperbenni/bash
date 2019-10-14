#!/usr/bin/env bash

pname wget/curl

getlinks() {
    echo "$1"
    curl -s "$1" |
        egrep -o '<a href=".*">.*</a>' |
        egrep -o '".*"' | egrep -o '[^"]*' |
        urldecode
}
