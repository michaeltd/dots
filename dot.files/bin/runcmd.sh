#!/usr/bin/env bash
#
# ~/runcmd.#!/bin/sh
# Simple app runner script.
# One line: TMPFILE=/tmp/${RANDOM}.input.box.txt && dialog --title 'Command Input' --default-button 'ok' --inputbox 'Enter command to continue' 10 40 command 2> ${TMPFILE} && $(cat ${TMPFILE})

DIALOG="$(command -v Xdialog || command -v dialog)"

TMPFILE="/tmp/${RANDOM}.input.box.txt"

"${DIALOG}" \
    --title "Command Input" \
    --default-button "ok" \
    --inputbox "Enter command to continue" \
    10 40 \
    command 2> "${TMPFILE}"

# RETVAL="${?}"

USRINPUT="$(cat "${TMPFILE}")"

"${USRINPUT}" >> "${TMPFILE}" 2>&1

exit "${?}"
