#
# environment variables
#shellcheck shell=bash

# Used by mc themes
export COLORTERM="truecolor"

# SUDO_ASKPASS
#shellcheck disable=SC2155
export SUDO_ASKPASS="$(type -P x11-ssh-askpass||type -P ssh-askpass-fullscreen)"

# Used by emacsclient in case of server not running.
#shellcheck disable=SC2155
export ALTERNATE_EDITOR="$(type -P emacs||type -P gvim||type -P kate||type -P gedit||type -P mousepad)" \
       TERMINAL_EDITOR="$(type -P emacs||type -P vim||type -P micro||type -P nano)"

export EDITOR="${TERMINAL_EDITOR}" VISUAL="${ALTERNATE_EDITOR}"

if [[ -n "${DISPLAY}" ]]; then
    #shellcheck disable=SC2155
    export BROWSER="$(type -P firefox ||type -P seamonkey)"
else
    #shellcheck disable=SC2155
    export BROWSER="$(type -P w3m||type -P links||type -P lynx)"
fi

#shellcheck disable=SC2155
export TERMINAL="$(type -P xterm||type -P konsole||type -P gnome-terminal||type -P terminology||type -P xfce4-terminal)"

# most > less > more in order of preference
#shellcheck disable=SC2155
export PAGER="$(command -v less 2>/dev/null || command -v most 2>/dev/null || type -P more 2>/dev/null)"

# manpager in case you'd like your manpages in your favorite editor
# export MANPAGER="env MAN_PN=1 vim -M +MANPAGER -"

# Man page wrapper
if command -v tput > /dev/null 2>&1; then
    man ()
    {
	# Color man pages
	env LESS_TERMCAP_mb="$(printf "%s" "$(tput bold)$(tput setaf 1)")" \
	    LESS_TERMCAP_md="$(printf "%s" "$(tput bold)$(tput setaf 1)")" \
	    LESS_TERMCAP_me="$(printf "%s" "$(tput sgr0)")" \
	    LESS_TERMCAP_se="$(printf "%s" "$(tput sgr0)")" \
	    LESS_TERMCAP_so="$(printf "%s" "$(tput bold)$(tput setab 4)$(tput setaf 3)")" \
	    LESS_TERMCAP_ue="$(printf "%s" "$(tput sgr0)")" \
	    LESS_TERMCAP_us="$(printf "%s" "$(tput bold)$(tput setaf 2)")" \
	    "$(command -v man 2> /dev/null)" "$@"
    }
else
    man ()
    {
	# Colorfull manpages (works with less as a pager)
	# https://www.tecmint.com/view-colored-man-pages-in-linux/
	env LESS_TERMCAP_mb=$'\e[1;32m' \
	    LESS_TERMCAP_md=$'\e[1;32m' \
	    LESS_TERMCAP_me=$'\e[0m' \
	    LESS_TERMCAP_se=$'\e[0m' \
	    LESS_TERMCAP_so=$'\e[01;33m' \
	    LESS_TERMCAP_ue=$'\e[0m' \
	    LESS_TERMCAP_us=$'\e[1;4;31m' \
	    "$(command -v man 2> /dev/null)" "${@}"
    }
fi

export LANG="en_US.utf8"
export LC_COLLATE="C"

export GIT_PS1_SHOWDIRTYSTATE=yes
export GIT_PS1_SHOWSTASHSTATE=yes
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWUPSTREAM=yes

# OPT
[[ -d "/opt" ]] && export OPT="/opt"
# JAVA
[[ -d "/opt/java" ]] && export JAVA_HOME="/opt/java"
[[ -d "/opt/ant" ]] && export ANT="/opt/ant"
[[ -d "/opt/maven" ]] && export MAVEN="/opt/maven"
[[ -d "/opt/gradle" ]] && export GRADLE="/opt/gradle"
# GO
[[ -d ~/"go" ]] && export GOPATH=~/"go"
# RUST
[[ -d ~/"cargo" ]] && export RUST=~/".cargo"
# NODE
[[ -d ~/".node" ]] && export NODE=~/".node"
# DENO
[[ -d ~/".deno" ]] && export DENO=~/".deno"
# MONGODB
[[ -d "/opt/mongodb" ]] && export MONGODB="/opt/mongodb"

checkpath()
{
    [[ "${PATH}" != *${1}* ]] && [[ -d "${1}" ]] && export PATH+=":${1}"
}
# Path with += op and each tool in it's own line for practical reasons
# [[ "${PATH}" == *${HOME}/.local/bin* ]] || { [[ -d ~/".local/bin" ]] && export PATH+=":${HOME}/.local/bin"; }
checkpath ${HOME}/.local/bin
# OPT
[[ -n "${OPT}" ]] && checkpath "${OPT}/bin"
checkpath "${HOME}/bin"
# JAVA
[[ -n "${JAVA_HOME}" ]] && checkpath "${JAVA_HOME}/bin"
[[ -n "${ANT}" ]] && checkpath "${ANT}/bin"
[[ -n "${MAVEN}" ]] && checkpath "${MAVEN}/bin"
[[ -n "${GRADLE}" ]] && checkpath "${GRADLE}/bin"
[[ -n "${GOPATH}" ]] && checkpath "${GOPATH}/bin"
# RUST
[[ -n "${RUST}" ]] && checkpath "${RUST}/bin"
# NODE
[[ -n "${NODE}" ]] && checkpath "${NODE}/bin"
# DENO
[[ -n "${DENO}" ]] && checkpath "${DENO}/bin"
# MONGODB
[[ -n "${MONGODB}" ]] && checkpath "${MONGODB}/bin"

# MANPATH
checkmpath()
{
    [[ "${MANPATH}" != *${1}* ]] && [[ -d "${1}" ]] && export MANPATH+=":${1}"
}
checkmpath "${HOME}/.local/share/man"
checkmpath "${HOME}/opt/share/man"

# JAVA classpath
checkcpath()
{
    [[ "${CLASSPATH}" != *${1}* ]] && [[ -d "${1}" ]] && export CLASSPATH+=":${1}"
}
[[ -n "${JAVA_HOME}" ]] && checkcpath "${JAVA_HOME}/lib"
[[ -n "${ANT}" ]] && checkcpath "${ANT}/lib"
[[ -n "${MAVEN}" ]] && checkcpath "${MAVEN}/lib"

unset -f checkpath checkmpath checkcpath
