#!/bin/bash
pushd ~/
if [ -e .bashfunctions.sh ]
then
  source .bashfunctions.sh
else
  curl https://raw.githubusercontent.com/paperbenni/bash/master/bash.sh > .bashfunctions.sh
  echo "paperbenni's bash tools successfully installed!"
  source .bashfunctions.sh
fi
popd