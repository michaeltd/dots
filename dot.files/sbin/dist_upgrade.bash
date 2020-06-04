#!/usr/bin/env bash
#
# Distro neutral upgrade script michaeltd 171124
# From https://en.wikipedia.org/wiki/Package_manager

# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\t\n'

dist_upgrade() {

    echo -ne " -- ${BASH_SOURCE[0]##*/} --\n"

    # For this to work package manager arrays must be in following format...
    # | #1 package manager executable | #2 repo update switch | #3 distro upgrade switch(es)| #4 ...
    # PS: By ignoring dpkg and rpm we are avoiding issues with systems where alien has been installed.
    #shellcheck disable=SC2034
    local -ra apt_get=( "apt-get" "update" "--assume-yes" "--simulate" "dist-upgrade" ) \
            yum=( "yum" "check-update" "update" ) \
            zypper=( "zypper" "refresh" "update" "--no-confirm" "--auto-agree-with-licenses" ) \
            pacman=( "pacman" "-Sy" "-Syu" ) \
            emerge=( "emerge" "--sync" "--pretend" "--nospinner" "--update" "--deep" "--newuse" "${1:-@world}" ) \
            pkg=( "pkg" "update" "upgrade" )

    local -ra pms=( apt_get[@] yum[@] zypper[@] pacman[@] emerge[@] pkg[@] )

    local -r notfound="404"

    local pmidx="${notfound}" x=""

    # Which is the first available pm in this system?
    for x in "${!pms[@]}"; do
	if type -P "${!pms[x]:0:1}"&>/dev/null; then
	    local -r pmidx="${x}"
	    break # break on first match.
	fi
    done

    if [[ "${pmidx}" == "${notfound}" || "${EUID}" != "0" ]]; then
	#shellcheck disable=SC2154
	printf " Error: required access privilages not met,\n or package manager not found. \n For this to work you need root account privilages \n and a %s, %s, %s, %s, %s or %s based distro.\n Quithing.\n" "${!pms[0]:0:1}" "${!pms[1]:0:1}" "${!pms[2]:0:1}" "${!pms[3]:0:1}" "${!pms[4]:0:1}" "${!pms[5]:0:1}" >&2
	return 1
    else
	time "${!pms[pmidx]:0:1}" "${!pms[pmidx]:1:1}" && time "${!pms[pmidx]:0:1}" "${!pms[pmidx]:2}"
    fi

}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    fn_nm="$(basename "${BASH_SOURCE[0]}")"
    fn_nm="${fn_nm%%.bash}"
    "${fn_nm}" "${@}"
fi
