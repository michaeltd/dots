#
# environment variables
#shellcheck shell=bash disable=SC2155

appendpath() {

    local envar="${1}"
    
    if [[ -n "${envar}" ]]; then
	[[ "${!envar}" != *${2}* ]] && [[ -d "${2}" ]] && export "${envar}"+=":${2}"
    else
	[[ -d "${2}" ]] && export "${envar}"="${2}"
    fi
}

# OPT
[[ -d "/opt" ]] && export OPT="/opt"
# JAVA
[[ -d "${HOME}/.jdk" ]] && export JAVA_HOME="${HOME}/.jdk"
[[ -d "${HOME}/.ant" ]] && export ANT="${HOME}/.ant"
[[ -d "${HOME}/.maven" ]] && export MAVEN="${HOME}/.maven"
[[ -d "${HOME}/.gradle" ]] && export GRADLE="${HOME}/.gradle"
# GO
[[ -d "${HOME}/.go" ]] && export GOPATH="${HOME}/.go"
# RUST
[[ -d "${HOME}/.cargo" ]] && export RUST="${HOME}/.cargo"
# ZIG
[[ -d "${HOME}/.zig" ]] && export ZIGPATH="${HOME}/.zig"
# NODE
[[ -d "${HOME}/.node" ]] && export NODE="${HOME}/.node"
# DENO
[[ -d "${HOME}/.deno" ]] && export DENO="${HOME}/.deno"
# MONGODB
[[ -d "${HOME}/.mongodb" ]] && export MONGODB="${HOME}/.mongodb"

appendpath "PATH" "${HOME}/.local/bin"
# OPT
[[ -n "${OPT}" ]] && appendpath "PATH" "${OPT}/bin"
appendpath "PATH" "${HOME}/bin"
# JAVA
[[ -n "${JAVA_HOME}" ]] && appendpath "PATH" "${JAVA_HOME}/bin"
[[ -n "${ANT}" ]] && appendpath "PATH" "${ANT}/bin"
[[ -n "${MAVEN}" ]] && appendpath "PATH" "${MAVEN}/bin"
[[ -n "${GRADLE}" ]] && appendpath "PATH" "${GRADLE}/bin"
[[ -n "${GOPATH}" ]] && appendpath "PATH" "${GOPATH}/bin"
# RUST
[[ -n "${RUST}" ]] && appendpath "PATH" "${RUST}/bin"
# ZIG
[[ -n "${ZIGPATH}" ]] && appendpath "PATH" "${ZIGPATH}"
# NODE
[[ -n "${NODE}" ]] && appendpath "PATH" "${NODE}/bin"
# DENO
[[ -n "${DENO}" ]] && appendpath "PATH" "${DENO}/bin"
# MONGODB
[[ -n "${MONGODB}" ]] && appendpath "PATH" "${MONGODB}/bin"

appendpath "MANPATH" "${HOME}/.local/share/man"
appendpath "MANPATH" "${HOME}/opt/share/man"

[[ -n "${JAVA_HOME}" ]] && appendpath "CLASSPATH" "${JAVA_HOME}/lib"
[[ -n "${ANT}" ]] && appendpath "CLASSPATH" "${ANT}/lib"
[[ -n "${MAVEN}" ]] && appendpath "CLASSPATH" "${MAVEN}/lib"

# Clean up functions
unset -f appendpath
# Used by mc themes
export COLORTERM="truecolor"

# SUDO_ASKPASS
export SUDO_ASKPASS="$(type -P x11-ssh-askpass||type -P ssh-askpass-fullscreen)"

# Used by emacsclient in case of server not running.
export ALTERNATE_EDITOR="$(type -P emacs||type -P gvim||type -P kate||type -P gedit||type -P mousepad)" \
       TERMINAL_EDITOR="$(type -P emacs||type -P vim||type -P micro||type -P nano)"

export EDITOR="${TERMINAL_EDITOR}" VISUAL="${ALTERNATE_EDITOR}"

if [[ -n "${DISPLAY}" ]]; then
    export BROWSER="$(type -P firefox ||type -P seamonkey)"
else
    export BROWSER="$(type -P w3m||type -P links||type -P lynx)"
fi

export TERMINAL="$(type -P sakura||type -P xterm||type -P konsole||type -P gnome-terminal||type -P terminology||type -P xfce4-terminal)"

# most > less > more in order of preference
export PAGER="$(type -P less 2>/dev/null || type -P most 2>/dev/null || type -P more 2>/dev/null)"

# manpager in case you'd like your manpages in your favorite editor
# export MANPAGER="env MAN_PN=1 vim -M +MANPAGER -"

# Man page wrapper
if type -P tput &>/dev/null; then
    man() {
	# Color man pages
	env LESS_TERMCAP_mb="$(printf "%s" "$(tput bold)$(tput setaf 1)")" \
	    LESS_TERMCAP_md="$(printf "%s" "$(tput bold)$(tput setaf 1)")" \
	    LESS_TERMCAP_me="$(printf "%s" "$(tput sgr0)")" \
	    LESS_TERMCAP_se="$(printf "%s" "$(tput sgr0)")" \
	    LESS_TERMCAP_so="$(printf "%s" "$(tput bold)$(tput setab 4)$(tput setaf 3)")" \
	    LESS_TERMCAP_ue="$(printf "%s" "$(tput sgr0)")" \
	    LESS_TERMCAP_us="$(printf "%s" "$(tput bold)$(tput setaf 2)")" \
	    "$(type -P man)" "$@"
    }
else
    man() {
	# Colorfull manpages (works with less as a pager)
	# https://www.tecmint.com/view-colored-man-pages-in-linux/
	env LESS_TERMCAP_mb=$'\e[1;32m' \
	    LESS_TERMCAP_md=$'\e[1;32m' \
	    LESS_TERMCAP_me=$'\e[0m' \
	    LESS_TERMCAP_se=$'\e[0m' \
	    LESS_TERMCAP_so=$'\e[01;33m' \
	    LESS_TERMCAP_ue=$'\e[0m' \
	    LESS_TERMCAP_us=$'\e[1;4;31m' \
	    "$(type -P man)" "${@}"
    }
fi

superman() {
  man $1 || $1 --help
}

alias man=superman
# export LANG="en_US.utf8"
# export LC_COLLATE="C"

export GIT_PS1_SHOWDIRTYSTATE=yes
export GIT_PS1_SHOWSTASHSTATE=yes
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWUPSTREAM=yes

