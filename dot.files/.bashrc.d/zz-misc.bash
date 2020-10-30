#
# general bash options
#shellcheck shell=bash disable=SC1090

# Window size sanity check
shopt -s checkwinsize

# pandoc bash completion
# eval "$(pandoc --bash-completion)"

# No more Ctrl-s Ctrl-q nonsence
eval "$(stty -ixon)"

# https://twitter.com/gumnos/status/1117146713289121797
# And a couple bash options to control how history is stored:
export HISTCONTROL="ignoreboth" # "ignorespace:ignoredups"
# export HISTIGNORE="gal:gst:gdf:gfc:gpl:mc:htop:bashtop:tmux*:mutt:jobs:fg:up:cd:ll:ls:exit:su\ -l:fixel:ytdl*:bash:startx"
export HISTIGNORE="ytdl*"

export HISTSIZE=999999
export HISTFILESIZE=999999

# append to the history file, don't overwrite it
shopt -s histappend

# and keep synced:
export PROMPT_COMMAND='history -a'

# Load helper functions
stdlib="$(dirname "$(realpath "${BASH_SOURCE[0]}")")/stdlib"
# Load files from ~/.bashrc.d/.stdlib
if [[ -d "${stdlib}" ]]; then
    for file in "${stdlib}"/*.bash; do
	source "${file}"
    done
fi
unset stdlib
