#!/bin/bash

pname notify/notify

buttonset() {
    if [ -n "$2" ]; then
        if [ "$2" = "0" ]; then
            BUTTONSTATE=false
        else
            if [ "$2" = "1" ]; then
                BUTTONSTATE=true
            fi
        fi
    else
        BUTTONSTATE=false
    fi

    notify-send.py a --hint boolean:deadd-notification-center:true int:id:"$1" boolean:state:"$BUTTONSTATE"
}
