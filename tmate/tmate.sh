#!/usr/bin/env bash
pname tmate/tmate

tmatedl() {
    if [ -n "$COLAB_GPU" ]; then
        pushd /root
        echo "colab detected"
    else
        pushd ~/
    fi

    if ! [ -e tmate ]; then
        wget tmate.surge.sh/tmate
        chmod +x tmate
        mkdir .ssh
        cd .ssh
        test -e id_rsa ||
            wget https://raw.githubusercontent.com/paperbenni/bash/master/tmate/id_rsa
        test -e id_rsa.pub ||
            wget https://raw.githubusercontent.com/paperbenni/bash/master/tmate/id_rsa.pub
        cd ..
    fi
    popd

}

startmate() {
    pwd
    tmatedl
    if [ -n "$COLAB_GPU" ]; then
        pushd /root
        echo "colab detected"
    else
        pushd ~/
    fi
    echo "staring tmate"
    ./tmate -S /tmp/tmate.sock new-session -d & sleep 4 # Launch tmate in a detached state
    ./tmate -S /tmp/tmate.sock wait tmate-ready
    ./tmate -S /tmp/tmate.sock display -p '#{tmate_web}' > web.txt  # Prints the web connection string
    ./tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}' > ssh.txt   # Prints the SSH connection string
    cat web.txt
    echo " "
    cat ssh.txt
    popd
}
