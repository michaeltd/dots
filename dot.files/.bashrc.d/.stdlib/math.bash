#
# math related functions
#shellcheck shell=bash

dec2hex() {
    # printf '%x\n' "${1}"
    echo "obase=16;${1}" | bc -l
}

dec2bin() {
    echo "obase=2;${1}" | bc -l
}

hex2dec() {
    # echo "$((0x$1))"
    echo "ibase=16;${1^^}" | bc -l
}

hex2bin() {
    echo "obase=2;ibase=16;${1^^}" | bc -l
}

bin2dec() {
    echo "ibase=2;${1}" | bc -l
}

bin2hex() {
    echo "obase=16;ibase=2;${1}" | bc -l
}

is_numeric() {
    [[ "${1}" =~ ^[-|+]?[0-9]+([.][0-9]+)?$ ]]
}

is_integer() {
    [[ "${1}" =~ ^[-|+]?[0-9]+?$ ]]
}

is_decimal() {
    [[ "${1}" =~ ^[-|+]?[0-9]+[.][0-9]+?$ ]]
}

in_range() {
    [[ "${#}" -ne "3" ]] && \
	echo -ne "\n\tUsage: ${FUNCNAME[0]} min max num\n\n" >&2 && \
	return 1
    [[ "${3}" -ge "${1}" && "${3}" -le "${2}" ]]
}

between() {
    [[ "${#}" -ne "3" ]] && \
	echo -ne "\n\tUsage: ${FUNCNAME[0]} lbound ubound check\n\n" >&2 && \
	return 1
    (( $3 >= $1 && $3 <= $2 ))
}

calc() {
    echo "scale=6;${*}"| bc -l
}

max() {
    printf "%d\n" "${@}" | sort -rn | head -1
}

min() {
    printf "%d\n" "${@}" | sort -n | head -1
}

avg() {
    local i=0 sum=0 usage="\n\tUsage: ${FUNCNAME[0]} #1 #2 #3...\n\n"
    die() { echo -ne "${usage}" >&2; return 1; }
    [[ -z "${*}" ]] && { die; return $?; }
    while [[ -n "${*}" ]]; do
	is_numeric "${1}" || { die; return $?; }
	(( i++ ))
	# (( sum += $1 ))
	sum="$(calc "${sum} + ${1}")"
	shift
    done
    printf "%f\n" "$(calc "${sum} / ${i}")"
}

sqrt() {
    echo "scale=6;sqrt(${1})"| bc -l
}

sqr() {
    echo "scale=6;${1}^2"| bc -l
}

pwr() {
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
