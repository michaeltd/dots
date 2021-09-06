#
# cryptographic functions
#shellcheck shell=bash disable=SC2005,SC2155,SC2086

gen_rnum() {
    LC_CTYPE=C tr -dc [:digit:] < /dev/urandom | \
	dd ibs=1 obs=1 count="${1:-16}" 2>/dev/null    
    echo
}

gen_pass() {
    LC_ALL=C tr -dc [:graph:] < /dev/urandom | \
	tr -d [=\"=][=\'=][=\|=][=\,=] | \
	dd ibs=1 obs=1 count="${1:-16}" 2>/dev/null
    echo
}

gen_uuid() {
    # local uuid="$(cat /proc/sys/kernel/random/uuid)"
    # echo "${uuid}"
    # https://en.wikipedia.org/wiki/Universally_unique_identifier
    # https://github.com/niieani/bash-oo-framework/blob/master/lib/String/UUID.sh
    # https://gist.github.com/markusfisch/6110640
    # https://github.com/lowerpower/UUID-with-bash
    mkpart() {
	# LC_CTYPE=C tr -dc "[a-f0-9]" < /dev/urandom | dd bs="${1}" count=1 2> /dev/null
	# LC_CTYPE=C tr -dc "abcdef0123456789" < /dev/urandom | dd bs="${1}" count=1 2> /dev/null
	LC_CTYPE=C tr -dc [:xdigit:] < /dev/urandom | dd bs="${1}" count=1 2> /dev/null
    }
    for i in {8,4,4,4,12}; do
	local uuid+="$(mkpart $i)-"
    done
    local uuid="${uuid%-}"
    printf "%s\n" "${uuid,,}"
}

hash_stdin() {
    [[ "${#}" -ne "1" ]] && \
	echo -ne "\n\tUsage: echo/cat \"text/file to hash\" | ${FUNCNAME[0]} cipher\n\n" >&2 && \
	return 1
    openssl dgst -"${1}"
}

transcode_stdin() {
    [[ "${#}" -ne "2" ]] && \
	echo -ne "\n\tUsage: echo/cat \"text/file to encode/decode\" | ${FUNCNAME[0]} (e/d) cipher\n\teg: echo 'Hello World'|transcode_stdin e blowfish\n\n" >&2 && \
	return 1
    openssl enc -base64 -"${2}" -"${1}"
}

transcode_gpg() {
    local myusage="
    Usage: ${FUNCNAME[0]} file(s)|file(s).gpg...
    Description: Decrypt/Encrypt files from/to your default gpg keyring.
    Examples: ${FUNCNAME[0]} *.txt *.gpg 
              # will encrypt .txt files and decrypt .gpg files in current dir.\n\n"

    [[ "${#}" -lt "1" ]] && echo -ne "${myusage}" >&2 && return 1

    while [[ -n "${1}" ]]; do
	case "${1}" in
	    -h|--help)
		shift
		echo -ne "${myusage}" >&2
		continue;;
	    *)
		if [[ -f "${1}" && -r "${1}" ]]; then
		    if [[ "$(file -b "${1}")" =~ ^PGP ]]; then
			if [[ "${1}" != "${1//.gpg/}" ]]; then
			    local func="--decrypt" out="${1//.gpg/}"
			elif [[ "${1}" != "${1//.pgp/}" ]]; then
			    local func="--decrypt" out="${1//.pgp/}"
			else
			    local func="--decrypt" out="${1}.dec"
			fi
		    else
			local func="--encrypt" out="${1}.gpg"
		    fi
		else
		    echo -ne "\t${1} is not a readable file!\n${myusage}" >&2
		    shift
		    continue
		fi;;
	esac
	gpg --default-recipient-self --output "${out}" "${func}" "${1}"
	shift
    done
}

rot_13() {
    [[ "${1}" != "-e" && "${1}" != "-d" ]] || [[ -z "${2}" ]] && \
	echo -ne "\n\tUsage: ${FUNCNAME[0]} [-(e|d)] [argument/(s)...]\n\n" >&2 && return 1

    local -a _ABC=( "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" \
			"K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" \
			"U" "V" "W" "X" "Y" "Z" )
    local -a _abc=( "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" \
			"k" "l" "m" "n" "o" "p" "q" "r" "s" "t" \
			"u" "v" "w" "x" "y" "z" )
    local -a _NOP=( "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" \
			"X" "Y" "Z" "A" "B" "C" "D" "E" "F" "G" \
			"H" "I" "J" "K" "L" "M" )
    local -a _nop=( "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" \
			"x" "y" "z" "a" "b" "c" "d" "e" "f" "g" \
			"h" "i" "j" "k" "l" "m" )

    local _func="${1}"; shift
    
    while [[ -n "${1}" ]]; do
	local _word="${1}"
	local _out
	for (( i = 0; i <= ${#_word}; i++ )); do
	    for (( x = 0; x <= ${#_abc[*]}; x++ )); do
		case "${_func}" in
		    "-e")
			[[ "${_word:i:1}" == "${_ABC[x]}" ]] && \
			    _out+="${_NOP[x]}" && break
			[[ "${_word:i:1}" == "${_abc[x]}" ]] && \
			    _out+="${_nop[x]}" && break;;
		    "-d")
			[[ "${_word:i:1}" == "${_NOP[x]}" ]] && \
			    _out+="${_ABC[x]}" && break
			[[ "${_word:i:1}" == "${_nop[x]}" ]] && \
			    _out+="${_abc[x]}" && break;;
		esac
		#If char has not been found by now lets add it as is.
		(( x == ${#_abc[*]} )) && _out+="${_word:i:1}" 
	    done
	done
	shift
	_out+=" "
    done
    echo "${_out[*]}"
}

caesar_cipher() {
    # michaeltd 2019-11-30
    # https://en.wikipedia.org/wiki/Caesar_cipher
    # E n ( x ) = ( x + n ) mod 26.
    # D n ( x ) = ( x − n ) mod 26.

    local -a _ABC=( "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" \
			"K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" \
			"U" "V" "W" "X" "Y" "Z" )
    local -a _abc=( "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" \
			"k" "l" "m" "n" "o" "p" "q" "r" "s" "t" \
			"u" "v" "w" "x" "y" "z" )

    local _out

    if [[ "${#}" -lt "3" ]] || \
	   [[ "$1" != "-e" && "$1" != "-d" ]] || \
	   [[ "${2}" -lt "1" || "${2}" -gt "25" ]]
    then
	echo -ne "\n\tUsage: ${FUNCNAME[0]} [-(e|d)] [rotation {1..25}] [argument/(s)...]\n\n" >&2
	return 1
    fi

    _func="${1}"; shift; _rotval="${1}"; shift

    while [[ -n "${1}" ]]; do
	for (( i = 0; i < ${#1}; i++ )); do
	    for (( x = 0; x < ${#_abc[*]}; x++ )); do
		case "${_func}" in
		    "-e")
			[[ "${1:i:1}" == "${_ABC[x]}" ]] && \
			    _out+="${_ABC[(( ( x + _rotval ) % 26 ))]}" && \
			    break
			[[ "${1:i:1}" == "${_abc[x]}" ]] && \
			    _out+="${_abc[(( ( x + _rotval ) % 26 ))]}" && \
			    break;;
		    "-d")
			[[ "${1:i:1}" == "${_ABC[x]}" ]] && \
			    _out+="${_ABC[(( ( x - _rotval ) % 26 ))]}" && \
			    break
			[[ "${1:i:1}" == "${_abc[x]}" ]] && \
			    _out+="${_abc[(( ( x - _rotval ) % 26 ))]}" && \
			    break;;
		esac
		# If char has not been found by now lets add it as is.
		(( x == ${#_abc[*]} - 1 )) && _out+="${1:i:1}"
	    done
	done
	_out+=" "
	shift
    done
    echo "${_out[*]}"
}

alpha2morse() {
    local -rA alpha_assoc=( \
        [A]='.-'    [B]='-...'  [C]='-.-.'  [D]='-..'    [E]='.' [F]='..-.' \
	[G]='--.'   [H]='....'  [I]='..'    [J]='.---'   [K]='-.-' \
	[L]='.-..'  [M]='--'    [N]='-.'    [O]='---'    [P]='.--.' \
	[Q]='--.-'  [R]='.-.'   [S]='...'   [T]='-'      [U]='..-' \
	[V]='...-'  [W]='.--'   [X]='-..-'  [Y]='-.--'   [Z]='--..' \
	[0]='-----' [1]='.----' [2]='..---' [3]='...--'  [4]='....-' \
	[5]='.....' [6]='-....' [7]='--...' [8]='----..' [9]='----.' )

    if [[ "${#}" -lt "1" ]]; then
	echo -ne "
	Usage: ${FUNCNAME[0]} arguments...
	Example: ${FUNCNAME[0]} Hello World
	Description: ${FUNCNAME[0]} is an IMC transmitter. 
		     It'll transmit your messages to International Morse Code.\n\n" >&2
	return 1
    fi

    while [[ -n "${1}" ]]; do
	for (( i = 0; i < ${#1}; i++ )); do
	    local letter="${1:i:1}"
	    for (( y = 0; y < ${#alpha_assoc[${letter^^}]}; y++ )); do
		case "${alpha_assoc[${letter^^}]:y:1}" in
		    ".")
			echo -n "dot "
			play -q -n -c2 synth .05 2> /dev/null || sleep .05 ;;
		    "-")
			echo -n "dash "
			play -q -n -c2 synth .15 2> /dev/null || sleep .15 ;;
		esac
		sleep .05
	    done
	    echo
	    sleep .15
	done
	echo
	sleep .35
	shift
    done
}
