#!/bin/sh

nine(){

  echo "ctrl-c detected"
}

trap nine 2

while :
do
  sleep 1
done
