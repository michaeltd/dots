# ~/.bashrc.d/.stdlib/math.bash
#
# math related functions
#shellcheck shell=bash

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
    local n=${1} # Avoid n initialization issues
    while [[ -n "${*}" ]]; do
	(( $1 < n )) && n="${1}"
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
    local x="${1}" # Avoid x initialization issues
    while [[ -n "${*}" ]]; do
	(( $1 > x )) && x="${1}"
	shift
    done
    echo "${x}"
}

avg() {
    local i=0 sum=0 usage="Usage: ${FUNCNAME[0]} #1 #2 #3..."
    die() { echo "${usage[*]}" >&2; return 1; }
    [[ -z "${*}" ]] && { die; return $?; }
    while [[ -n "${*}" ]]; do
	[[ "${1}" =~ ^[0-9]+$ ]] || { die; return $?; }
	(( i++ )); (( sum += $1 )); shift
    done
    printf "%d\n" "$(( sum / i ))"
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
