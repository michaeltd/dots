#!/usr/bin/env -S bash --norc --noprofile
#shellcheck shell=bash disable=SC1008,SC2096
#
# Simple password cli

# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\t\n'

#link free (S)cript: (D)ir(N)ame, (B)ase(N)ame.
#shellcheck disable=SC2155,SC2034
readonly sdn="$(dirname "$(realpath "${BASH_SOURCE[0]}")")" \
	 sbn="$(basename "$(realpath "${BASH_SOURCE[0]}")")"

passcli() {
    local -ra pgpc=( "gpg" "--quiet" "--batch" "--yes" "--default-recipient-self" "--output" ) \
	  shrc=( "shred" "--zero" "--remove" )
    local -r pass_file="${HOME}/.passfile"
    local -r pass_pgp="${pass_file}.pgp" pass_bck="${pass_file}.bck"
    local -r pass_header="
    '########:::::'###:::::'######:::'######:::'######::'##:::::::'####:
     ##.... ##:::'## ##:::'##... ##:'##... ##:'##... ##: ##:::::::. ##::
     ##:::: ##::'##:. ##:: ##:::..:: ##:::..:: ##:::..:: ##:::::::: ##::
     ########::'##:::. ##:. ######::. ######:: ##::::::: ##:::::::: ##::
     ##.....::: #########::..... ##::..... ##: ##::::::: ##:::::::: ##::
     ##:::::::: ##.... ##:'##::: ##:'##::: ##: ##::: ##: ##:::::::: ##::
     ##:::::::: ##:::: ##:. ######::. ######::. ######:: ########:'####:
     ..:::::::::..:::::..:::......::::......::::......:::........::....::
     "

    show_header() { type -P lolcat &>/dev/null && echo "${pass_header}"|lolcat || echo "${pass_header}"; }

    usage() { echo -ne "\n Usage: ${sbn} add 'domain,uname,pass' | find keyword | rem keyword... | show | halp\n\n" >&2; }

    encrypt() { "${pgpc[@]}" "${pass_pgp}" "--encrypt" "${pass_file}" && "${shrc[@]}" {"${pass_file}","${pass_bck}"} 2> /dev/null; }

    #shellcheck disable=SC2015
    decrypt() { [[ -e "${pass_pgp}" ]] && "${pgpc[@]}" "${pass_file}" "--decrypt" "${pass_pgp}" || touch "${pass_file}"; }

    show() { nl -b a "${pass_file}"; }

    find() { grep -h "${1}" "${pass_file}"; }

    rem() {
	grep -h "${1}" "${pass_file}"
	if [[ "$(read -rp "Delete above entr(y/ies) from password file? [y/N] " r;echo "${r:-N}")" == [Yy]* ]]; then
            cp -f "${pass_file}" "${pass_bck}"
            grep -hv "${1}" "${pass_bck}" > "${pass_file}"
	fi
    }

    add() { echo "${*}" >> "${pass_file}"; show; }

    case "${*}" in
	add*|rem*|find*|show*) show_header; decrypt; "${@}"; encrypt;;
	*) show_header; usage; return 1;;
    esac
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && "${sbn%.*}" "${@}"
