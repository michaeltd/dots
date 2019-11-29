#!/bin/bash
#
# https://en.wikipedia.org/wiki/Morse_code
#
# International Morse Code
# 1. Length of dot is 1 unit
# 2. Length of dash is 3 units
# 3. The space between parts of the same letter is 1 unit
# 4. The space between letters is 3 units.
# 5. The space between words is 7 units.
################################################################################

alpha2morse() {
  local -A alpha_assoc=( [A]='.-' [B]='-...' [C]='-.-.' [D]='-..' [E]='.' [F]='..-.' [G]='--.' [H]='....' [I]='..' [J]='.---' [K]='-.-' [L]='.-..' [M]='--' [N]='-.' [O]='---' [P]='.--.' [Q]='--.-' [R]='.-.' [S]='...' [T]='-' [U]='..-' [V]='...-' [W]='.--' [X]='-..-' [Y]='-.--' [Z]='--..' [0]='-----' [1]='.----' [2]='..---' [3]='...--' [4]='....-' [5]='.....' [6]='-....' [7]='--...' [8]='----..' [9]='----.' )

  if [[ "${#}" -lt "1" ]]; then
    echo -ne "Usage: ${FUNCNAME[0]} arguments...\n ${FUNCNAME[0]} is an IMC transmitter. \n It'll transmit your messages to International Morse Code.\n" >&2
    return 1
  fi

  while [[ -n "${1}" ]]; do
    local word="${1}"
    for (( i = 0; i < ${#word}; i++ )); do
      local letter="${word:${i}:1}"
      local ml="${alpha_assoc[${letter^^}]}"
      for (( y = 0; y < ${#ml}; y++ )); do
        case "${ml:${y}:1}" in
          ".") echo -n "dot "; play -q -n synth .1 2> /dev/null || sleep .1 ;;
          "-") echo -n "dash "; play -q -n synth .3 2> /dev/null || sleep .3 ;;
        esac
        sleep .1
      done
      echo
      sleep .3
    done
    echo
    sleep .7
    shift
  done
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  alpha2morse "${@}"
fi
