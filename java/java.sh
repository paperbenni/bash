#!/usr/bin/env bash
pname java/java

jwindow() {
    export _JAVA_AWT_WM_NONREPARENTING=1
    java -jar "$1"
}
