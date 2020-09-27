#!/usr/bin/env bash
pname ngrok/emkc

emkc() {
    nohup autossh -L $1:127.0.0.1:$2 root@emkc.org -N
}
