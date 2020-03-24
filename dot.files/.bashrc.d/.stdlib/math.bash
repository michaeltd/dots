# ~/.bashrc.d/.stdlib/math.bash
#
# math related functions
#shellcheck shell=bash

rom2dec() {
    # https://rosettacode.org/wiki/Roman_numerals/Decode#UNIX_Shell
    local -ra ROM=( I V X L C D M ) DEC=( 1 5 10 50 100 500 1000 )
    while [[ -n "${1}" ]]; do
	local NUM="${1}" RES=0 PRE=0
	for (( i = ${#NUM}-1; i >= 0; i-- )); do
	    for (( x = ${#ROM[*]} - 1 ; x >= 0  ; x-- )); do
		if [[ "${NUM:$i:1}" == "${ROM[x]}" ]]; then
		    local DIG="${DEC[x]}"
		    break
		fi
	    done
	    (( DIG < PRE )) && (( RES -= DIG )) || (( RES += DIG ))
	    PRE="${DIG}"
	done
	echo "$NUM = $RES"
	shift
    done
}

dec2rom() {
    # https://rosettacode.org/wiki/Roman_numerals/Encode#UNIX_Shell
    local values=( 1000 900 500 400 100 90 50 40 10 5 4 1 )
    local roman=(
        [1000]=M [900]=CM [500]=D [400]=CD 
         [100]=C  [90]=XC  [50]=L  [40]=XL 
          [10]=X   [9]=IX   [5]=V   [4]=IV   
           [1]=I
    )
    local nvmber=""
    local num=$1
    for value in ${values[@]}; do
        while (( num >= value )); do
            nvmber+=${roman[value]}
            ((num -= value))
        done
    done
    echo $nvmber
}
 
in_range() {
    if [[ "${#}" -eq "3" ]]; then
	[[ "${3}" -ge "${1}" && "${3}" -le "${2}" ]]
    else
	echo "Usage: ${FUNCNAME[0]} min max num" >&2
	return 1
    fi
}

between() {
    [[ "${#}" -ne "3" ]] && \
	echo "Usage: ${FUNCNAME[0]} lbound ubound check" >&2 && \
	return 1
    (( $3 >= $1 && $3 <= $2 ))
}

calc() {
    echo "scale=6;${*}"| bc -l
}

altmin() {
    printf "%s\n" "${@}" | \
	sort -n | \
	head -1
}

min() {
    n=${1} # Avoid n initialization issues
    while [[ -n "${1}" ]]; do
	(( $1 < n )) && n=${1}
	shift
    done
    echo "${n}"
}

altmax() {
    printf "%d\n" "${@}" | \
	sort -rn | \
	head -1
}

max() {
    local x
    x="${1}" # Avoid x initialization issues
    while [[ -n "${1}" ]]; do
	(( $1 > x )) && x="${1}"
	shift
    done
    echo "${x}"
}

sqrt() {
    echo "scale=6;sqrt(${1})"| bc -l
}

sqr() {
    echo "scale=6;${1}^2"| bc -l
}

powr() {
    echo "scale=6;${1}^${2}"| bc -l
}

# Trigonometric functions
# https://advantage-bash.blogspot.com/2012/12/trignometry-calculator.html
sin() {
    echo "scale=6;s(${1})" | bc -l
}

cos() {
    echo "scale=6;c(${1})" | bc -l
}

tan() {
    echo "scale=6;s(${1})/c(${1})" | bc -l
}

csc() {
    echo "scale=6;1/s(${1})" | bc -l
}

sec() {
    echo "scale=6;1/c(${1})" | bc -l
}

ctn() {
    echo "scale=6;c(${1})/s(${1})" | bc -l
}

asin() {
    if (( $(echo "${1} == 1" | bc -l) )); then
	echo "90"
    elif (( $(echo "${1} < 1" | bc -l) )); then
	echo "scale=6;a(sqrt((1/(1-(${1}^2)))-1))" | bc -l
    elif (( $(echo "${1} > 1" | bc -l) )); then
	echo "error"
    fi
}

acos() {
    if (( $(echo "${1} == 0" | bc -l) )); then
	echo "90"
    elif (( $(echo "${1} <= 1" | bc -l) )); then
	echo "scale=6;a(sqrt((1/(${1}^2))-1))" | bc -l
    elif (( $(echo "${1} > 1" | bc -l) )); then
	echo "error"
    fi
}

atan() {
    echo "scale=6;a(${1})" | bc -l
}

acot() {
    echo "scale=6;a(1/${1})" | bc -l
}

asec() {
    echo "scale=6;a(sqrt((${1}^2)-1))" | bc -l
}

acsc() {
    echo "scale=6;a(1/(sqrt(${1}^2)-1))" | bc -l
}
