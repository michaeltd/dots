# ~/.bashrc.d/misc.bash
#
# general bash options

#shellcheck shell=bash

# Window size sanity check
shopt -s checkwinsize

# pandoc bash completion
# eval "$(pandoc --bash-completion)"

# https://twitter.com/gumnos/status/1117146713289121797
# And a couple bash options to control how history is stored:
#HISTCONTROL=ignorespace:ignoredups:ignoreboth
HISTCONTROL=ignorespace:ignoredups
HISTIGNORE=su\*:ll\*:ls\*:cd\*:pwd:gal:gcm:gps:gal:gst:fg:htop:up
HISTSIZE=999999
HISTFILESIZE=999999

# append to the history file, don't overwrite it
shopt -s histappend

# and keep synced:
export PROMPT_COMMAND='history -a'

# Load helper functions
stl="${HOME}/.bashrc.d/.stl"
# Load files from ~/.bashrc.d/.stl
if [[ -d "${stl}" ]]; then
  for file in "${stl}"/*; do
    #shellcheck disable=SC1090
    source "${file}"
  done
fi
