#!/usr/bin/env bash
#
# man qcheck : qcheck - verify integrity of installed packages

type -P emerge &>/dev/null || { echo -ne "Not an portage based distro!\n" >&2; exit 1; }
type -P qcheck &>/dev/null || { echo -ne "qcheck not found!\n" >&2; exit 1; }
[[ "${EUID}" -eq "0" ]] || { echo -ne "Privilaged access requirements not met!\n" >&2; exit 1; }

time qcheck --quiet --nocolor --badonly

