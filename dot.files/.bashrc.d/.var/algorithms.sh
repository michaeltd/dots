# ~/.bashrc.d/algorithms.sh
#
# common algorithms in bash
#shellcheck shell=bash

fizzbuzz() {
    [[ -z "${1}" ]] && echo "Usage: ${FUNCNAME[0]} count" && return 1
    for (( cnt = 1; cnt <= $1; cnt++ )); do
	if (( cnt % 15 == 0 )); then
	    echo "fizzbuzz"
	elif (( cnt % 5 == 0 )); then
	    echo "buzz"
	elif (( cnt % 3 == 0 )); then
	    echo "fizz"
	else
	    echo "${cnt}"
	fi
    done
}

# Iterative
fibonacciIterative() {
    fib=1
    j=1
    for (( c = 1; c < $1; c++ )); do
	(( k = fib + j, fib = j, j = k ))
    done
    echo "${fib}"
}

# Recursive
fibonacciRecursive() {
    if [[ "${1}" -le "0" ]]; then
	echo 0
	return 0
    fi
    if [[ "${1}" -le "2" ]]; then
	echo "1"
    else
	a="$(fibonacciRecursive "$(( $1 - 1 ))")"
	b="$(fibonacciRecursive "$(( $1 - 2 ))")"
	echo "$(( a + b ))"
    fi
}

factorial() {
  # https://rosettacode.org/wiki/Factorial
    if [[ "${1}" -le "1" ]]; then
	echo "1"
    else
	result="$(factorial $(( ${1} - 1 )))"
	echo "$(( result * ${1} ))"
    fi
}

bessel() {
    # https://www.reddit.com/r/bash/comments/ax0ah0/crude_bessel_graph/
    # [order] [limit] Crude bessel graph
    # example: for n in {0..19}; do bessel $n $((LINES/2)); sleep 1; done

    local int="${1:-9}" limit="${2:-200}"

    for (( i =- limit; i <= limit; i++ )); do
	pad=$(bc -l <<< "j($int,$i)*($COLUMNS/2)+($COLUMNS/2)+.5")
	printf '% *d\n' "${pad%.*}" $i
	sleep .03
    done
}
