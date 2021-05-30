# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
# umask 022

# if running bash
# if [[ -n "$BASH_VERSION" ]]; then
# include .bashrc if it exists
# if [[ -f "$HOME/.bashrc" ]]; then
# source "$HOME/.bashrc"
# fi
# fi

# [[ -n "$BASH_VERSION" && -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc"

# set ENV to a file invoked each time sh is started for interactive use.
ENV=$HOME/.shrc; export ENV

if [ -x /usr/bin/fortune ] ; then /usr/bin/fortune freebsd-tips ; fi
