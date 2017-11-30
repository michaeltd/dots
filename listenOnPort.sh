#!/usr/bin/env /bin/bash

# Returns service listening on given port
if [[ -z "${1}" ]]; then
  printf "port number expected\n"
  exit 1
else
  lsof -n -iTCP:"${1}" | grep LISTEN
fi
