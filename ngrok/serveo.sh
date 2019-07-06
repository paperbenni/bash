#!/usr/bin/env bash
pname ngrok/serveo

spigotserveo() {
    nohup autossh -M 0 -R "$1":localhost:25565 serveo.net
}
