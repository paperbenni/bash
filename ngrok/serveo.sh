#!/usr/bin/env bash
pname ngrok/serveo

serveo() {
    if [ -z "$3" ]; then
        echo "usage: serveo localport remoteport server"
        return
    fi
    autossh -M 0 -R "$2":localhost:"$1" "$3"
}

spigotserveo() {
    nohup autossh -M 0 -R "$1":localhost:25565 serveo.net
}
