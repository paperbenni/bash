#!/bin/bash
installcode() {
  curl -o code.deb https://github.com/paperbenni/bash/raw/master/vscode/code.deb
  sudo dpkg -y -i code.deb
  rm code.deb
}
