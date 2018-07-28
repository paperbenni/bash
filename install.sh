#!/bin/bash
if grep -q paperbennibash01 ~/.bashrc; then
  echo "already installed"
else
  echo paperbennibash01 >> .bashrc
  echo "sucessfully installed paperbenni's bash tools!"
  #add actual installation here
fi
