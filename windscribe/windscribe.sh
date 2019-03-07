#!/usr/bin/env bash


#this script is unfinished

windscribe() {
    if ! [ -e ~/.config/windscribe/windscribe ]; then
        mkdir -p ~/.config/windscribe
        wget #windscribe url
        chmod +x windscribe
    fi

    ~/.config/windscribe/windscribe "$@"
}

wvpn() {
    if ! pgrep windscribe; then
        if ! windscribe --version; then
            echo "windscribe not working"
            exit 1
        fi
        sudo windscribe start
    fi

    WINDSTRING=$(windscribe connect)
    if echo "$WINDSTRING" | grep "Please login to use Windscribe"
    then
        #windscribe login
    else
        echo "windscribe connected successfully"
    fi

}
