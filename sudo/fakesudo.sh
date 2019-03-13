#!/usr/bin/env bash
sudo() {

    for argument in "$@"; do
        if echo "$argument" | grep -w '\-.*' >/dev/null; then
            shift
        else
            echo "broke at $argument"
            break
        fi
    done
    eval "$@"

}
