#!/usr/bin/env /bin/bash

TS="$(date +%y%m%d.%H%M%S)"
SIG="${HOST}.${USER}.${TS}"
app=$(which "${1}" 2> /dev/null)
errcode=""
stdout="/tmp/${SIG}.out.txt"
stderr="/tmp/${SIG}.err.txt"
stdin="/tmp/${SIG}.sdi.txt"

if [[ -x "${app}" ]]; then
  "${@}" 1> "${stdout}" 2> "${stderr}"
  errcode="${?}"
else
  printf "Need exactly one executable as argument\n"
  exit 1
fi

printf "## command completed with status code = %d\n" "${errcode}"

printf "## standard out START:\n"

cat "${stdout}"

printf "## standard out END.\n"

printf "## standard error START:\n"

cat "${stderr}"

printf "## standard error END.\n"
