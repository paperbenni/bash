# paperbenni/bash

A collection of neat little bash functions.
Meant for use in Scripting

## Usage in scripts

### Instructions

Add the following line to the top of your bash script to get started using my functions

```sh
source <(curl -Ls https://git.io/JerLG)
```

Then do the following to import functions into your script
*pb* supports the following three types of syntax
```sh
#here are a few examples
pb unpack # just the name if there are no other scripts in the category
pb rclone/login.sh # full name with file extension
pb spigot/op # full name without file extension
pb rclone.login # full name without file extension and dot as seperator

#lets try them out
unpack
  usage: unpack file
  automatically detects the archive type and extracts it
```

### Demo

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/2edb0989a07f40919cd0472a6a91fdaf)](https://app.codacy.com/manual/paperbenni/bash?utm_source=github.com&utm_medium=referral&utm_content=paperbenni/bash&utm_campaign=Badge_Grade_Settings)
[![asciicast](https://asciinema.org/a/uLkrlqR36UwAe5MJIXtGjH6uV.svg)](https://asciinema.org/a/uLkrlqR36UwAe5MJIXtGjH6uV)

These my personal scripts.

I hold no responsibility for them being difficult to
use or causing the end of the world

If you want to contribute, feel free to send pull requests. 

debugger:
```sh
source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/setup.sh)
```

### Alternative sourcing oneliner
```sh
{ command -v papertest && papertest; } || source <(curl -Ls https://git.io/JerLG)
```