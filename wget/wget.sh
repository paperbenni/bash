#!/usr/bin/env bash
pname wget/wget
pb wget/fakebrowser

# download all files of a given format from an index
downloadformat() {
    INDEX="${2:-index.html}"
    if grep "$1" <"$INDEX"; then
        grep -Eo 'src=".*/.*\.'"$1"'"' <"$INDEX" | grep -Eo '".*"' | grep -Eo '[^"]*' >cache.html

        while read p; do
            if grep -q 'http' <<<"$p"; then
                wget "$p"
            else
                if [ -n "$3" ]; then
                    echo "$3$p"
                    #wget "$3$p"
                fi
            fi
        done <cache.html
        rm cache.html
    fi
}

# download all images from a single webpage
downloadimages() {
    mkdir .imagecache
    cd .imagecache
    fakebrowser "$1"
    DOMAIN2=$(grep -Eo 'http[s:]{,3}//[^/]*/' <<<"$1")
    DOMAIN="${DOMAIN2%/}"
    SINDEX="$(ls)"

    for FMT in jpg png jpeg gif; do
        downloadformat "$FMT" "$SINDEX" "$DOMAIN"
    done

    rm "$SINDEX"
    mv ./* ../
    cd ..
    rm -r .imagecache
}
