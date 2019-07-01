#!/usr/bin/env bash
pname sudo/fakesudo
# emulates sudo on non-sudo systems like docker containers
# so that bash scripts containing sudo can be run without modifications
if ! command -v sudo; then
    sudo() {

        for argument in "$@"; do
            if echo "$argument" | grep -q -w '\-.*'; then
                shift
            else
                echo "running $argument"
                break
            fi
        done
        eval "$@"

    }
else
    echo "found normal sudo"
fi
