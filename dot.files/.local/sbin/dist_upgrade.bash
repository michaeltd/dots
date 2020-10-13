#!/usr/bin/env -S bash --norc --noprofile
#shellcheck shell=bash disable=SC1008,SC2096
#shellcheck disable=SC2155,SC2034,SC2154
#
# Distro neutral upgrade script michaeltd 171124
# From https://en.wikipedia.org/wiki/Package_manager

# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\t\n'

#link free (S)cript: (D)ir(N)ame, (B)ase(N)ame.
readonly sdn="$(dirname "$(realpath "${BASH_SOURCE[0]}")")" \
	 sbn="$(basename "$(realpath "${BASH_SOURCE[0]}")")"

main() {
    # For this to work package manager arrays must be in following format...
    # | #1 package manager executable | #2 repo update switch | #3 distro upgrade switch(es)| #4 ...
    # PS: By ignoring dpkg and rpm we are avoiding issues with systems where alien has been installed.
    local -ra apt_get=( "apt-get" "update" "--assume-yes" "--simulate" "dist-upgrade" ) \
            yum=( "yum" "check-update" "update" ) \
            zypper=( "zypper" "refresh" "update" "--no-confirm" "--auto-agree-with-licenses" ) \
            pacman=( "pacman" "-Sy" "-Syu" ) \
            emerge=( "emerge" "--sync" "--pretend" "--nospinner" "--update" "--deep" "--newuse" "${1:-@world}" ) \
            pkg=( "pkg" "update" "upgrade" )

    local -ra pms=( apt_get[@] yum[@] zypper[@] pacman[@] emerge[@] pkg[@] )

    local -r notfound="404"

    local pmidx="${notfound}"

    # Which is the first available pm in this system?
    for x in "${!pms[@]}"; do
	if type -P "${!pms[x]:0:1}" &> /dev/null; then
	    local -r pmidx="${x}"
	    break # break on first match.
	fi
    done

    if [[ "${pmidx}" == "${notfound}" || "${EUID}" != "0" ]]; then
	printf " Error: required access privilages not met,\n or package manager not found. \n For this to work you need root account privilages \n and a %s, %s, %s, %s, %s or %s based distro.\n Quithing.\n" "${!pms[0]:0:1}" "${!pms[1]:0:1}" "${!pms[2]:0:1}" "${!pms[3]:0:1}" "${!pms[4]:0:1}" "${!pms[5]:0:1}" >&2
	return 1
    else
	"${!pms[pmidx]:0:1}" "${!pms[pmidx]:1:1}" && "${!pms[pmidx]:0:1}" "${!pms[pmidx]:2}"
    fi
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "${@}"
