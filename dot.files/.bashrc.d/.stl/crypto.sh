# ~/.bashrc.d/crypto.sh
#
# cryptographic functions
#shellcheck shell=bash

genpass() {
  #tr -dc [:graph:] < /dev/urandom|tr -d [=\|=][=\"=][=\'=]|head -c "${1:-64}"
  #tr -dc '[:alnum:]~!@#$%^&*()_=+,<.>/?;:[{]}\|-' < /dev/urandom|head -c "${1:-64}"
  #shellcheck disable=SC2005
  echo "$(tr -dc '[:alnum:]~!@#$%^_+:?' < /dev/urandom|head -c "${1:-64}")"
}

rot_13(){
  local _func="${1}"
  shift

  [[ "${_func}" != "-e" && "${_func}" != "-d" ]] || [[ -z "${1}" ]] && echo "Usage: ${FUNCNAME[0]} -e|-d argument(s)..." && return 1
  #----------------1---2---3---4---5---6---7---8---9--10--11--12--13--14--15--16--17--18--19--20--21--22--23--24--25--26---
  local -a _ABC=( "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" )
  local -a _abc=( "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" )
  local -a _NOP=( "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" )
  local -a _nop=( "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" )

  while [[ -n "${1}" ]]; do
    local _word="${1}"
    local _out
    for (( i = 0; i <= ${#_word} ; i++ )); do
      for (( x = 0; x <= ${#_abc[*]} ; x++ )); do
        case "${_func}" in
          "-e")
            [[ "${_word:$i:1}" == "${_ABC[$x]}" ]] && _out+="${_NOP[$x]}" && break
            [[ "${_word:$i:1}" == "${_abc[$x]}" ]] && _out+="${_nop[$x]}" && break;;
          "-d")
            [[ "${_word:$i:1}" == "${_NOP[$x]}" ]] && _out+="${_ABC[$x]}" && break
            [[ "${_word:$i:1}" == "${_nop[$x]}" ]] && _out+="${_abc[$x]}" && break;;
        esac
        (( x == ${#_abc[*]} )) && _out+="${_word:$i:1}" #If char has not been found by now lets add it as is.
      done
    done
    shift
    _out+=" "
  done
  echo "${_out[*]}"
}

rot_0_26(){

  _usage(){
    echo "Usage: ${FUNCNAME[1]} -e|-d ROTVAL(int 0-26) argument[(s)...]"
  }

  local _argn="${#}"
  local _func="${1}"
  shift

  local _rotval="${1}"
  shift

  (( _argn < 3 )) && _usage && return 1
  [[ "${_func}" != "-e" && "${_func}" != "-d" ]] && _usage && return 1
  [[ "${_rotval}" =~ ^[0-9]{1,2}$ ]] && (( _rotval >= 0 && _rotval <= 26 )) || _usage && return 1

  #----------------1---2---3---4---5---6---7---8---9--10--11--12--13--14--15--16--17--18--19--20--21--22--23--24--25--26---
  local -a _ABC=( "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" )
  local -a _abc=( "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" )
  #local -a _NOP=( "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" )
  #local -a _nop=( "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" )

  # SO FAR SO GOOD   !!!
  while [[ -n "${1}" ]]; do
    local _word="${1}"
    local _out
    for (( i = 0; i <= ${#_word} ; i++ )); do
      for (( x = 0; x <= ${#_abc[*]} ; x++ )); do
        case "${_func}" in
          "-e")
            [[ "${_word:$i:1}" == "${_ABC[$x]}" ]] && _out+="${_NOP[$x]}" && break
            [[ "${_word:$i:1}" == "${_abc[$x]}" ]] && _out+="${_nop[$x]}" && break;;
          "-d")
            [[ "${_word:$i:1}" == "${_NOP[$x]}" ]] && _out+="${_ABC[$x]}" && break
            [[ "${_word:$i:1}" == "${_nop[$x]}" ]] && _out+="${_abc[$x]}" && break;;
        esac
        (( x == ${#_abc[*]} )) && _out+="${_word:$i:1}" #If char has not been found by now lets add it as is.
      done
    done
    shift
    _out+=" "
  done
  echo "${_out[*]}"
}
