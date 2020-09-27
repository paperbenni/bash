#!/bin/bash

pname notify/notify

buttonset() {
    [ "$2" = "1" ] && BUTTONSTATE=true
    notify-send.py a --hint boolean:dead-notification-center:true int:id:"$1" boolean:state:"${BUTTONSTATE:-false}"
}
