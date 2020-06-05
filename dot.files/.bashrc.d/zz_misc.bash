#
# general bash options

#shellcheck shell=bash

# Window size sanity check
shopt -s checkwinsize

# pandoc bash completion
# eval "$(pandoc --bash-completion)"

# No more Ctrl-s Ctrl-q nonsence
eval "$(stty -ixon)"

# https://twitter.com/gumnos/status/1117146713289121797
# And a couple bash options to control how history is stored:
export HISTCONTROL=ignoreboth # ignorespace:ignoredups
export HISTIGNORE=""

export HISTSIZE=999999
export HISTFILESIZE=999999

# append to the history file, don't overwrite it
shopt -s histappend

# and keep synced:
export PROMPT_COMMAND='history -a'

# Load helper functions
sl="${HOME}/.bashrc.d/.stdlib"
# Load files from ~/.bashrc.d/.stdlib
if [[ -d "${sl}" ]]; then
    for file in "${sl}/"*.bash; do
	#shellcheck disable=SC1090
	source "${file}"
    done
fi
