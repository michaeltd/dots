#!/usr/bin/env -S bash --norc --noprofile
#shellcheck shell=bash disable=SC1008,SC2096
#

#shellcheck disable=SC2155,SC2034
readonly script_dir_name="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
readonly script_base_name="$(basename "$(realpath "${BASH_SOURCE[0]}")")"
readonly script_pid="${$}"
readonly version=1.0
readonly version_text="Boilerplate for new scripts v$version"
readonly options="h o: q v V"
readonly help_text="Usage: $script_base_name [-o <text>] [-hqvV] [<file>]...

Boilerplate for new scripts

        -o <text>  Set an option with a parameter
        -h         Display this help text and exit
        -q         Quiet
        -v         Verbose mode
        -V         Display version information and exit"

clean_exit() {
	_exit_status=$?
	trap - EXIT
	info "exiting"

	[ $# -ne 0 ] && {
	    trap - "$1"
	    kill -s "$1" -$$
	}
	exit "$_exit_status"
}

error() { 
	_error=${1:-1}
	shift
	printf '%s: Error: %s\n' "$script_base_name" "$*" >&2
	exit "$_error"
}

usage() {
	[ $# -ne 0 ] && {
	    exec >&2
	    printf '%s: %s\n\n' "$script_base_name" "$*"
	}
	printf '%s\n' "$help_text"
	exit ${1:+1}
}

info()    { printf '%s\n' "$*" >&2; }

version() { printf '%s\n' "$version_text"; exit; }

# For a given optstring, this function sets the variables
# "option_<optchar>" to true/false and param_<optchar> to its parameter.
parse_options() {
    for _opt in $options; do
	# The POSIX spec does not say anything about spaces in the
	# optstring, so lets get rid of them.
	_optstring=$_optstring$_opt
	eval "option_${_opt%:}=false"
    done

    while getopts ":$_optstring" _opt; do
	case $_opt in
	    :) usage "option '$OPTARG' requires a parameter" ;;
	    \?) usage "unrecognized option '$OPTARG'" ;;
	    *)
		eval "option_$_opt=true"
		[ -n "$OPTARG" ] && eval "param_$_opt=\$OPTARG"
		;;
	esac
    done
    unset _opt _optstring OPTARG
}

# shellcheck disable=2034,2046
set_defaults() {
    # Unofficial Bash Strict Mode
    set -euo pipefail
    IFS=$'\t\n'

    trap 'clean_exit' EXIT TERM
    trap 'clean_exit HUP' HUP
    trap 'clean_exit INT' INT
    # IFS=' '
    # set -- $(printf '\n \r \t \033')
    declare -x nl=$'\n' cr=$'\r' tab=$'\t' esc=$'\033'
    # IFS=\ $tab
}

template() {
    set_defaults
    parse_options "$@"
    shift $((OPTIND-1))
    # If we want to use `getopts` again, this has to be set to 1.
    OPTIND=1

    # shellcheck disable=2154
    {
	$option_h && usage
	$option_V && version
	$option_q && info() { :; }
	$option_o && info "option 'o' has parameter '$param_o'"
	$option_v && info "verbose mode is on"
    }
    
    _i=1

    for _file
    do
	info "operand $_i is '$_file'"
	_i=$((_i+1))
    done
    
    unset _i _file
    
    [ -t 0 ] || info "stdin is not a terminal"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && "${script_base_name%.*}" "$@"
