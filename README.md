# paperbenni/bash

A collection of neat little bash functions.

## Usage in scripts

Add the following line to the top of your bash script to get started using my functions

```sh
source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
```

Then do the following to import functions into your script

```
$ #here are a few examples
$ pb unpack/unpack.sh
$ pb rclone/login.sh

$ #lets try them out
$ unpack
usage: unpack file
automatically detects the archive type and extracts it
```

These my personal scripts.

I hold no responsibility for them being difficult to
use or causing the end of the world
