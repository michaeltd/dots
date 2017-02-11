#!/bin/bash

if [ -z "$1" ]; then
  curl wttr.in/Athens
else
  curl wttr.in/"$1"
fi
