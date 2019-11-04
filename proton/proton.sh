#!/usr/bin/env bash
pname proton/proton

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)

# installs, logs in and connects to ProtonVPN
proton() {
    if ! sudo --version &>/dev/null; then
        pb sudo/fakesudo
    fi

    mkdir -p ~/.proton
    pushd ~/.proton
    if ! (
        for i in python openvpn wget dialog pvpn expect; do
            command -v $i
        done

    ); then
        pb install
        pinstall python openvpn dialog wget expect iptables
        sudo wget -O protonvpn-cli.sh https://raw.githubusercontent.com/ProtonVPN/protonvpn-cli/master/protonvpn-cli.sh -q --show-progress
        sudo chmod +x protonvpn-cli.sh
        sudo ./protonvpn-cli.sh --install
    fi

    sudo -S rm -rf ~/.protonvpn-cli
    wget https://raw.githubusercontent.com/paperbenni/bash/master/proton/login.sh -q --show-progress
    chmod +x login.sh
    sudo ./login.sh "cpiedl" "retro123"
    sudo pvpn -d
    sudo pvpn -c "US-FREE#2" tcp
    rm login.sh
    sudo rm protonvpn-cli.sh
    popd

}
