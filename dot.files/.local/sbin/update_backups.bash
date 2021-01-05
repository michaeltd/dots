#!/usr/bin/env -S bash --norc --noprofile
#shellcheck shell=bash disable=SC1008,SC2096,SC2155,SC2034,SC2046
#
# Configure backups with ${sbn%%.*}.include.(encrypt|compress).job_name definition files

# Unofficial Bash Strict Mode
set -uo pipefail
IFS=$'\t\n'

#link free (S)cript: (D)ir(N)ame, (B)ase(N)ame.
readonly sdn="$(dirname "$(realpath "${BASH_SOURCE[0]}")")" \
	 sbn="$(basename "$(realpath "${BASH_SOURCE[0]}")")"

main() {
    local definitions="${HOME}/.${sbn%%.*}" backup2="/mnt/data/Documents/bkp/linux" recipient="tsouchlarakis@gmail.com" niceness="19"
    local myusage="
    Usage: ${sbn} [-(-f)rom /path/to/defs] [-(-t)o /path/to/backups] [-(-k)ey some@key.org] [-(-n)iceness {0..19}] [-(-d)ebug] [-(-h)elp]

    -(-f)rom /path/to/defs            where to read definitions from. Default: $definitions
    -(-t)o /path/to/backups           where to save backups to. Default: $backup2
    -(-k)ey some@key.org 	      key to encrypt to. Default: $recipient
    -(-n)iceness {0..19} 	      niceness to run with. Default: $niceness
    -(-d)ebug		      	      display lots of words. Default: OFF
    -(-h)elp			      This screen.

    Prereq's you'll need for this to work:
    1) Some include/exclude files to describe your backup jobs, -f switch. (see bellow)
    2) A path to place your backup files, -t switch.
    3) A \$recipient public key to encrypt to, -k switch.
       NOTE: add your \$recipient public key to root's keyring, If you link this to /etc/cron.anything

    Include/Exclude file details.

    ${sbn%%.*}.include.*.* file name explanation:
    /path/to/defs/${sbn%%.*}.include.compress|encrypt.job_name
    '            '                      '                '        '
          1                 2                    3            4
    1) This part will be given by your [-(-f)rom] switch (default \"${definitions}\")
       The script will use it as a starting point to search for all ${sbn%%.*}.* related files.
    2) ${sbn%%.*}.include.* will be the search term for the definitions files.
    3) This part should be aither *.encrypt.* or *.compress.*.
       encrypt file definitions will result in encrypted tarballs,
       compress file definitions will result in unencrypted tarballs.
    4) The last part serves as the jobs name.
       It will end up in the resulting *.tar.gz.pgp or *.tar.gz file name.

    Sample ${sbn%%.*}.include.*.* file contents:
    /home/username/git/.
    /home/username/Documents/.

    Sample ${sbn%%.*}.exclude file contents:
    */.git/*
    */.github/*
    */node_modules/*

"

    log2err() { echo -ne "${sbn}: ${*}\n" >&2; }
    
    while [[ -n "${*}" ]]; do
	case "${1}" in
	    -f|--from) shift; definitions="${1}";;
	    -t|--to) shift; backup2="${1}";;
	    -k|--key) shift; recipient="${1}";;
	    -n|--niceness) shift; [[ "${1}" =~ ^[-|+]?[0-9]+?$ ]] && (( $1 >= 0 && $1 <= 19 )) && niceness="${1}";;
	    -d|--debug) set -x;;
	    -h|--help) log2err "${myusage}"; return 1;;
	    *) log2err "Unknown option ${1}\n${myusage}"; return 1;;
	esac
	shift
    done

    local -ra includes=( "${definitions}/${sbn%%.*}.include".* )
    local -r exclude="${definitions}/${sbn%%.*}.exclude" job_fn="${backup2}/${HOSTNAME}.$(date -u +%y%m%d.%H%M.%s)"

    [[ -r "${includes[0]}" ]] || { log2err "No readable job file definitions found.\nNothing left to do!"; return 1; }
    [[ -d "${backup2}" ]] || { log2err "${backup2} is not a directory."; return 1; }

    local -ra nice_cmd=( "nice" "-n" "${niceness}" ) \
	  tar_cmd=( "tar" "--create" "--gzip" "$([[ -r "${exclude}" ]] && echo -n "--exclude-from=${exclude}")" "--exclude-backups" "--one-file-system" ) \
	  pgp_cmd=( "gpg" "--batch" "--yes" "--recipient" "${recipient}" "--trust-model" "always" "--output" )

    compress() {
	local job_out="${job_fn}.${1##*.}.tar.gz"
	"${nice_cmd[@]}" "${tar_cmd[@]}" "--file" "${job_out}" $(cat "${1}")
	local err=$?
	if (( err == 0 )); then
	    log2err "Wrote: ${job_out##*/}"
	else
	    rm -f "${job_out}" # Wipe half baked archives (from reboots, shutdowns, etc)
	    log2err "Discarded: ${job_out##*/}, error level is $err. Job \"${1##*.}\" Failed!"
	fi
    }

    encrypt() {
	local job_out="${job_fn}.${1##*.}.tar.gz.pgp"
	"${nice_cmd[@]}" "${tar_cmd[@]}" $(cat "${1}") | "${pgp_cmd[@]}" "${job_out}" "--encrypt"
	local err=$?
	if (( err == 0 )); then
	    log2err "Wrote: ${job_out##*/}"
	else
	    rm -f "${job_out}" # Wipe half baked archives (from reboots, shutdowns, etc)
	    log2err "Discarded: ${job_out##*/}, error level is $err. Job \"${1##*.}\" Failed!"
	fi
    }

    for include in "${includes[@]}"; do
	[[ ${include} =~ (compress|encrypt) ]] && "${BASH_REMATCH[1]}" "${include}"
    done
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "${@}"
