#!/bin/bash
installcode() {
  curl -o code.deb https://az764295.vo.msecnd.net/stable/c6e592b2b5770e40a98cb9c2715a8ef89aec3d74/code_1.30.0-1544567151_amd64.deb
  sudo dpkg -y -i code.deb
  rm code.deb
}