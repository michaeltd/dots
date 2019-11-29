#!/bin/sh
#
# generate a strong random password of given size.

#echo $(tr -dc '[:alnum:]~!@#$%^&*()_=+,<.>/?;:[{]}\|-' < /dev/urandom|head -c "${1:-64}")
#shellcheck disable=SC2005 # need that newline "\n"
echo "$(tr -dc "[:graph:]" < /dev/urandom|tr -d "[=\"=][=\'=]"|head -c "${1:-64}")"
