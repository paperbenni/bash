#!/usr/bin/env bash

pname wget/curl

getlinks() {
    curl "$1" |
        egrep -o '<a href=".*">.*</a>' |
        egrep -o '".*"' | egrep -o '[^"]*' |
        urldecode
}
