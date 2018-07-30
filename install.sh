#!/bin/bash
install(){
  echo "#paperbennibash01" >> .bashrc
  echo "sucessfully installed paperbenni's bash tools!"
  echo "$(curl https://raw.githubusercontent.com/paperbenni/bash/master/setup.sh) >> .bashrc
  echo "appended functions"
}

if [ -e ~/.bashrc ]
then
  echo "bashrc found"
else
  touch .bashrc
fi

if grep -q paperbennibash01 ~/.bashrc; then
  echo "already installed"
else
  install
fi
