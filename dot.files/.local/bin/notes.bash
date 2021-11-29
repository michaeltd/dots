#!/usr/bin/env -S bash --norc --noprofile
#
# https://www.reddit.com/r/bash/comments/fxxtav/simple_notes/
# Simple notes
# I use the following to keep track of minutia and thought it might be helpful to someone else. I use it for when someone suggests a movie or TV show, or birthday gift thoughts, etc. Basically anything that you might use a post-it for.

#link free (S)cript (B)ase (N)ame.
readonly sbn="$(basename "$(realpath "${BASH_SOURCE[0]}")")"

main() {
    local -ra pgpc=( "gpg" "--quiet" "--batch" "--yes" "--default-recipient-self" "--output" )
    type -P shred &> /dev/null && local -ra shrc=( "$(type -P shred 2> /dev/null)" "--zero" "--remove" ) || local -ra shrc=( "$(type -P rm 2> /dev/null)" "-P" "-f" )
    local -r notes_file="${HOME}/.${USER}.${sbn%.*}"
    local -r notes_gpg="${notes_file}.gpg" notes_bkp="${notes_file}.bkp"
    local -r notes_header='
          ::::    ::: ::::::::::::::::::::::::::::::::::::: 
         :+:+:   :+::+:    :+:   :+:    :+:      :+:    :+: 
        :+:+:+  +:++:+    +:+   +:+    +:+      +:+         
       +#+ +:+ +#++#+    +:+   +#+    +#++:++# +#++:++#++   
      +#+  +#+#+#+#+    +#+   +#+    +#+             +#+    
     #+#   #+#+##+#    #+#   #+#    #+#      #+#    #+#     
    ###    #### ########    ###    ##################       
    '
    show_header() { clear; type -P lolcat &>/dev/null && echo "${notes_header}"| lolcat || echo "${notes_header}"; }

    usage() { echo -ne "\n Usage: ${sbn} add 'some notes'|rem keyword...|list [keyword]\n\n" >&2; }

    encrypt() { "${pgpc[@]}" "${notes_gpg}" "--encrypt" "${notes_file}" && "${shrc[@]}" {"${notes_file}","${notes_bkp}"} 2> /dev/null; }

    decrypt() {	if [[ -e "${notes_gpg}" ]]; then "${pgpc[@]}" "${notes_file}" "--decrypt" "${notes_gpg}"; else echo 'Date|Time|Note' > "${notes_file}";	fi; }

    list() { grep -h "${1}" "${notes_file}" |column -t -s '|' |nl -s ':' -b p[0-9] |"${PAGER}"; }

    rem() { list "${1}"; if [[ "$(read -rp "Delete above entr(y/ies) from notes? [y/N] " r;echo "${r:-N}")" == [Yy]* ]]; then cp -f "${notes_file}" "${notes_bkp}"; grep -hv "${1}" "${notes_bkp}" > "${notes_file}"; fi; }

    add() { echo "$(date +%F\|%T)|${*}" >> "${notes_file}"; }

    case "${1}" in
	add |rem |list) show_header; decrypt && "${@}" && encrypt;;
	*) show_header; usage; return 1;;
    esac
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "${@}"
