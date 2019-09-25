# paperbenni/bash

A collection of neat little bash functions.

## Usage in scripts

### Instructions

Add the following line to the top of your bash script to get started using my functions

```sh
source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
```

Then do the following to import functions into your script
*pb* supports the following three types of syntax
```sh
#here are a few examples
pb unpack # just the name if there are no other scripts in the category
pb rclone/login.sh # full name with file extension
pb spigot/op # full name without file extension

#lets try them out
unpack
  usage: unpack file
  automatically detects the archive type and extracts it
```

### Demo

[![asciicast](https://asciinema.org/a/ieoK56ZmQlXtttQyAOrF2pP8R.svg)](https://asciinema.org/a/ieoK56ZmQlXtttQyAOrF2pP8R)

These my personal scripts.

I hold no responsibility for them being difficult to
use or causing the end of the world

debugger:
```sh
source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/setup.sh)
```
