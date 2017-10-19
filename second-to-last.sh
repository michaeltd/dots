#!/usr/bin/env /bin/bash

pth="${HOME}/Documents/test"
fls=($(ls "${pth}"))

for fl in ${fls[@]} ; do
  fn="${pth}/${fl}"
  if [[ -f "${fn}" ]]; then
    printf "FILE: %s \n" "${fl}"
    tail -n 2 "${fn}" |head -n 1
  fi
done
