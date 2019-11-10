# ~/.bashrc.d/misc.sh
#
# general bash options

# Window size sanity check
shopt -s checkwinsize

# pandoc bash completion
# eval "$(pandoc --bash-completion)"

# https://twitter.com/gumnos/status/1117146713289121797
# And a couple bash options to control how history is stored:
HISTCONTROL=ignorespace:erasedups
HISTIGNORE=ll:ls:cd:pwd
HISTSIZE=10000
HISTFILESIZE=20000

# append to the history file, don't overwrite it
shopt -s histappend

# and keep synced:
export PROMPT_COMMAND='history -a'


# Load helper functions
stdl="${HOME}/.bashrc.d/.stdl"

if [[ -d "${stdl}" ]] # Load files from ~/.bashrc.d/.stdl
then

  for file in ${stdl}/*
  do

    source "${file}"
  done
fi
