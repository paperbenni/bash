#!/usr/bin/env bash

fakebrowser() {
    wget --content-disposition --trust-server-names --header="Accept: text/html" --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0" "$1"
}
