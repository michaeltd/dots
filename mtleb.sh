#!/bin/bash
# https://wiki.gentoo.org/wiki/Project:Proxy_Maintainers/
fgrep -l maintainer-needed /usr/portage/*/*/metadata.xml |cut -d/ -f4-5 |fgrep -x -f <(EIX_LIMIT=0 eix -I --only-names)
