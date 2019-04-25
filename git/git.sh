#!/usr/bin/env bash
pname git/git

gitfolder() {
    svn export https://github.com/"$1".git/trunk/"$2"
}
