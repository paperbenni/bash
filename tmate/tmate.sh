#!/usr/bin/env bash
pname tmate/tmate

tmatedl() {
    pushd ~/
    if ! [ -e tmate ]; then
        wget tmate.surge.sh/tmate
        chmod +x tmate
    fi
    popd
    if [ -e ~/.ssh/id_rsa ]; then
        echo "ssh keys found"
    else
        ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
    fi
}

startmate() {
    tmatedl
    ~/tmate -S /tmp/tmate.sock new-session -d # Launch tmate in a detached state
    ~/tmate -S /tmp/tmate.sock wait tmate-ready
    ~/tmate -S /tmp/tmate.sock display -p '#{tmate_web}' >web.txt # Prints the web connection string
    ~/tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}' >ssh.txt # Prints the SSH connection string
    cat web.txt
    echo " "
    cat ssh.txt
}
