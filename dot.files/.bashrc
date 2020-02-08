# /etc/skel/.bashrc
esbrc="/etc/skel/.bashrc"
if [[ -f "${esbrc}" ]]; then
    source "${esbrc}"
fi

export COLORTERM="truecolor"

# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]]; then
    # Shell is non-interactive.  Be done now!
    return
fi

# Put your fun stuff here.
gps="/usr/share/git/git-prompt.sh"
[[ -r "${gps}" ]] && source "${gps}"

bcnf="${HOME}/git/utils/bash-insulter/src/bash.command-not-found"
[[ -r "${bcnf}" ]] && source "${bcnf}"

brcd="${HOME}/.bashrc.d"
if [[ -d "${brcd}" ]]; then # Load files from ~/.bashrc.d
    for file in "${brcd}"/*; do
        source "${file}"
    done
fi
