#!/usr/bin/env bash
htime() {
    heroku ps -a "$1" | grep 'usage' | egrep -o '[0-9]*%' | egrep -o '[0-9]*'
}
