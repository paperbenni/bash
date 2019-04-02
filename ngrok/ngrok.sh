#!/bin/bash

# installs ngrok binary into ~/ngrok/ngrok
ngrokdl() {
    mkdir "$HOME"/ngrok &>/dev/null
    cd "$HOME"/ngrok
    echo "downloading ngrok"

    if grep -i 'Alpine' </etc/os-release; then
        echo "alpine detected, using 32bit"
        wget ngrok.surge.sh/ngrok32 -q --show-progress
        mv ngrok32 ngrok
    else
        wget ngrok.surge.sh/ngrok -q --show-progress

        if [ "$1" = "nochmod" ]; then
            echo "skipping chmod"
        else
            chmod +x "$HOME"/ngrok/ngrok
            if ! "$HOME"/ngrok/ngrok --version; then
                echo "failed"
            fi
            return 1
        fi
    fi
}

#finds and executes ngrok with the specified arguments
exegrok() {
    if ngrok --version &>/dev/null; then
        ngrok "$@"
    else
        if ! ~/ngrok/ngrok --version &>/dev/null; then
            ngrokdl
        fi
        ~/ngrok/ngrok "$@"
    fi
}

#automatically logs in and runs ngrok
rungrok() {

    mkdir -p ~/.ngrok2

    while true; do
        curl "https://raw.githubusercontent.com/paperbenni/bash/master/ngrok/tokens.txt" >./ngroktokens.txt
        rm ~/.ngrok2/ngrok.yml
        exegrok authtoken $(shuf -n 1 ./ngroktokens.txt)
        rm ./ngroktokens.txt
        if ! [ -z "$PORT" ] && ! grep "$PORT" <~/.ngrok2/ngrok.yml; then
            echo "Setting ngrok port to $PORT"
            echo 'web_addr: localhost:'"$PORT" >>~/.ngrok2/ngrok.yml
        fi

        sleep 2
        exegrok "$@"
        sleep 5
    done

}

#gets your ngrok adress into stdout
getgrok() {
    NGROKPROTOCOLL="tcp"
    if [ -n "$1" ]; then
        NGROKPROTOCOLL="$1"
    fi
    curl localhost:4040/api/tunnels | grep -oP "$NGROKPROTOCOLL"'://.*?:[0-9]*'

}

waitgrok() {
    while ! curl localhost:4040/api/tunnels; do
        echo "waiting for ngrok"
        sleep 4
    done
    echo "ngrok found"
}
