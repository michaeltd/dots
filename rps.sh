#!/bin/env /bin/bash
# Rock Paper Scissors mt 20170525
declare -a op; declare -a oc; declare -A rs
op=("Rock" "Paper" "Scissors")
oc=("WIN" "Defeat" "Draw")
rs[0,0]=${oc[2]}; rs[0,1]=${oc[1]}; rs[0,2]=${oc[0]}
rs[1,0]=${oc[0]}; rs[1,1]=${oc[2]}; rs[1,2]=${oc[1]}
rs[2,0]=${oc[1]}; rs[2,1]=${oc[0]}; rs[2,2]=${oc[2]}
cs=0; us=0; ns=0; rd=0
printf "Hello! Welcome to %s %s %s Game!\n" ${op[0]} ${op[1]} ${op[2]}
while true; do
  read -e -p "${op[0]}:1, ${op[1]}:2, ${op[2]}:3, Quit:0. What's your pick?: " ui
  case "${ui}" in
    0)
      if [ "$us" -gt "$cs" ] ; then
        bbmsg="${oc[0]}"
      elif [ "$us" -lt "$cs" ] ; then
        bbmsg="got ${oc[1]}ed by"
      elif [ "$us" -eq "$cs" ] ; then
        bbmsg="${oc[2]}ed with"
      fi
      printf "After %d rounds, you %s the CPU with %d:%d points and %d ties.\n" $rd "${bbmsg}" $us $cs $ns
      exit 0
      ;;
    [1-3])
      let "rd++"
      let "ui = $ui - 1"
      ci=$(shuf -i 0-2 -n 1)
      printf "Round : %d is a %s. You selected %s, while the CPU rolled %s\n" $rd ${rs["${ui}","${ci}"]}  ${op["${ui}"]} ${op["${ci}"]}
      case ${rs["${ui}","${ci}"]} in
        ${oc[0]}) let "us++";;
        ${oc[1]}) let "cs++";;
        ${oc[2]}) let "ns++";;
      esac
      printf "Player : %d, CPU : %d, Ties : %d\n" $us $cs $ns
      ;;
    *)
      printf "Choose again from 0 to 3\n"
      ;;
  esac
done
