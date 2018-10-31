#!/usr/bin/env bash

cd /myDir

declare -a files=( $(ls -t) )

for (( x=0; x<="${#files[@]}"; x++ )); do
  if (( "x" > "3" )); then
    # Test this to see if it prints the files you want deleted
    # If you feel confident with the results, uncomment the rm line
    printf "${files[$x]} \n"
    # rm "${files[$x]}"
  fi
done