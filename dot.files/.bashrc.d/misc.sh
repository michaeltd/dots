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
stl="${HOME}/.bashrc.d/.stl"

# Load files from ~/.bashrc.d/.stl
if [[ -d "${stl}" ]]
then

  for file in ${stl}/*
  do

    source "${file}"
  done
fi
