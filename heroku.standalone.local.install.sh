#!/bin/env /bin/bash

# Run this from your terminal.

# Replace OS with one of “linux”, “darwin”, “windows”, “freebsd”, “openbsd”

# Replace ARCH with one of “amd64”, “386” or “arm”

# wget https://cli-assets.heroku.com/branches/stable/heroku-OS-ARCH.tar.gz

wget https://cli-assets.heroku.com/branches/stable/heroku-linux-amd64.tar.gz

mkdir -p /usr/local/lib /usr/local/bin

tar -xvzf heroku-linux-amd64.tar.gz -C /usr/local/lib

ln -s /usr/local/lib/heroku/bin/heroku /usr/local/bin/heroku

# ensure that /usr/local/bin is in the PATH environment variable
