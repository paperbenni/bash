#!/bin/bash

exegrok() {
    if ngrok --version &>/dev/null; then
        ngrok "$@"
    else
        if ! ~/ngrok/ngrok --version &>/dev/null; then
            mkdir -p ~/ngrok &>/dev/null
            pushd ~/ngrok
            echo "downloading ngrok"
            wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip -q --show-progress
            unzip *.zip || (echo "unzip utility not found, please install!" && return 1)
            rm *.zip
            chmod +x ngrok
            if ! ./ngrok --version; then
                echo "failed"
                return 1
            fi
            popd
        fi
        ~/ngrok/ngrok "$@"
    fi
}

rungrok() {

    mkdir -p ~/.ngrok2

    while true; do
        curl "https://raw.githubusercontent.com/paperbenni/bash/master/ngrok/tokens.txt" >./ngroktokens.txt
        exegrok authtoken $(shuf -n 1 ./ngroktokens.txt)
        rm ./ngroktokens.txt
        sleep 5
        exegrok "$@"
        sleep 5
    done

}

getgrok() {
    curl localhost:4040/api/tunnels | grep -oP 'tcp://.*?:[0-9]*'
}
