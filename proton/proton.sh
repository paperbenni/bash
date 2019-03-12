#!/usr/bin/env bash

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)

proton() {

    mkdir -p ~/.proton
    pushd ~/.proton
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
    sudo pvpn -d
    sudo pvpn -c "US-FREE#2" tcp
    rm login.sh protonvpn-cli.sh
    popd

}
