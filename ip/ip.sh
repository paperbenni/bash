#!/bin/bash

pname ip/ip

getlocalip() {
    INTERFACE=$(ip addr | awk '/state UP/ {print $2}' | sed 's/.$//')
    if [ $(echo "$INTERFACE" | wc -l) -gt 1 ]; then
        echoerr "error: more than one network interface found"
        return 1
    fi
    ip addr | grep -A2 "$INTERFACE" | grep -o 'inet .*/' | grep -o '[0-9\.]*'
}

getpublicip() {
    curl ifconfig.me
}
