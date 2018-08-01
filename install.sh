#!/bin/bash
install(){
  echo '#paperbennibash01' >> ~/.bashrc
  echo "sucessfully installed paperbenni's bash tools!"
  curl https://raw.githubusercontent.com/paperbenni/bash/master/setup.sh >> ~/.bashrc
  mkdir .paperbenni
}

if [ -e ~/.bashrc ]
then
  echo "bashrc found"
else
  touch ~/.bashrc
  echo "bashrc created"
fi

if grep -q "paperbennibash01" ~/.bashrc
then
  echo "already installed"
else
  install
fi
