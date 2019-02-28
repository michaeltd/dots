# ~/.bashrc.d/misc
#
#

# Add to history instead of overriding it
shopt -s histappend

# Window size sanity check
shopt -s checkwinsize

# pandoc bash completion
eval "$(pandoc --bash-completion)"
