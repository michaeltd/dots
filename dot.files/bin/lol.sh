#!/bin/sh
#
# Pipe fortune through cowsay and lolcat for some color magic
# requires fortune, cowsay, lolcat-c.

fortune -o|cowsay -f "${1:-eyes}"|lolcat
