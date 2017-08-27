#!/bin/env /bin/bash

if [ -z "${1}" ]; then
  echo "need start or stop parameter"
  exit 1
else
  srvcs="postgresql-9.5 vsftpd apache2"
  for srvc in $srvcs; do
    rc-service "${srvc}" "${1}"
  done
fi
