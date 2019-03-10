#!/usr/bin/env bash

pb() {
    if [ -z "$@" ]; then
        echo "usage: pb bashfile"
    fi
    for FILE in "$@"; do
        curl "https://raw.githubusercontent.com/paperbenni/bash/master/$1" >temp.sh
        source temp.sh
        rm temp.sh
    done
}

proton() {
    (
        python --version
        openvpn --version
        wget --version
        dialog --version
        pvpn --version
    ) &>/dev/null
    EXITCODE="$?"

    if ! [ "$EXITCODE" = 0 ]; then
        pb install/install.sh
        pinstall python openvpn dialog wget expect
        sudo wget -O protonvpn-cli.sh https://raw.githubusercontent.com/ProtonVPN/protonvpn-cli/master/protonvpn-cli.sh
        sudo chmod +x protonvpn-cli.sh
        sudo ./protonvpn-cli.sh --install
    fi

    sudo -S rm -rf ~/.protonvpn-cli
    wget https://raw.githubusercontent.com/paperbenni/bash/master/proton/login.sh
    chmod +x login.sh
    sudo ./login.sh "cpiedl" "retro123"
    sudo pvpn -c "US-FREE#2" tcp


}
