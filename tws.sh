#!/usr/bin/env /bin/bash

# tws.sh stands for Trivial Web Scrapper Shell Script

# from https://www.joyofdata.de/blog/using-linux-shell-web-scraping/
# echo "http://www.bbc.com" |
#   wget -O- -i- |
#   hxnormalize -x |
#   hxselect -i "div.most_popular_content" |
#   lynx -stdin -dump > theMostPoupularInNews

# tsouchlarakis@gmail.com 2017-08-31

#wget -qO- http://en.wiktionary.org/wiki/robust |
#  hxnormalize -x |
#  hxselect "ol" |
#  lynx -stdin -dump -nolist

wget=`which wget`
hxselect=`which hxselect`
hxnormalize=`which hxnormalize`
lynx=`which lynx`
of=out.txt

if [[ -z "${1}" || -z "${2}" || -z "${hxselect}" || -z "${lynx}" || -z "${wget}" ]]; then
  echo "Requires wget, lynx, html-xml-utils installed and two parameters: 1) A web page (eg http://en.wiktionary.org/wiki/robust) and 2) An inner html css selector (eg ol). Like so: tws.sh http://en.wiktionary.org/wiki/robust ol"
else
  "${wget}" -qO- "${1}"|"${hxnormalize}" -x |"${hxselect}" "${2}" |"${lynx}" -stdin -dump -nolist > "${of}"
fi

cat "${of}"
