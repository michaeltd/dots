#!/bin/env /bin/bash

echo -e "#dev-perl/*\n#perl-core/*" > /etc/portage/package.mask/perl.mask

emerge -1 perl-cleaner

emerge -1O dev-lang/perl

perl-cleaner --all

echo -e "dev-perl/*\nperl-core/*" > /etc/portage/package.mask/perl.mask
