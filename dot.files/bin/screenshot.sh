#!/usr/bin/env bash
#
# ~/bin/screenshot.sh
# Take a screenshot. Requires Imagemagic or scrot, ristretto or viewnior.

FN="${HOME}/ScreenShot-$(date +%s).png"

#shellcheck disable=SC2015
import -delay 1 -window root "${FN}" || scrot --delay 1 "${FN}" && ristretto "${FN}" || viewnior "${FN}"
