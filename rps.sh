#!/bin/env /bin/bash
# Rock Paper Scissors mt 20170525
declare -a op; declare -A rs
op=("Rock" "Paper" "Scissors")
rs[0,0]="Draw";   rs[0,1]="Defeat"; rs[0,2]="Win"
rs[1,0]="Win";    rs[1,1]="Draw";   rs[1,2]="Defeat"
rs[2,0]="Defeat"; rs[2,1]="Win";    rs[2,2]="Draw"
cs=0; us=0; ns=0; rd=0

printf "Hello! Welcome to Rock-Paper-Scissors Game!\n"
while true; do
  printf "Press 1 for Rock, 2 for Paper, 3 for Scissors or 0 to Quit.\n"
  read -e -p "Select your weapon of choice from 1 to 3: " ui
  let "ui = $ui - 1"
  ci=$(shuf -i 0-2 -n 1)
  if [ "$ui" -eq "-1" ]; then
    if [ "$us" -gt "$cs" ] ; then
      bbmsg="WON"
    elif [ "$us" -lt "$cs" ] ; then
      bbmsg="lost to"
    elif [ "$us" -eq "$cs" ] ; then
      bbmsg="Tied with"
    fi
    printf "After %d rounds, you %s the CPU with %d:%d points and %d ties.\n" $rd "${bbmsg}" $us $cs $ns
    exit 0
  fi
  let "rd++"
  printf "Round : %d is a %s. You selected %s, while the CPU rolled %s\n" $rd ${rs["${ui}","${ci}"]}  ${op["${ui}"]} ${op["${ci}"]}
  case ${rs["${ui}","${ci}"]} in
    "Draw")
      let "ns++";;
    "Win")
      let "us++";;
    "Defeat")
      let "cs++";;
  esac
  printf "Player : %d, CPU : %d, Ties : %d\n" $us $cs $ns
done
