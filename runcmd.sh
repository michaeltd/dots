#!/bin/bash

DIALOG=${1-"Xdialog"}

TMPFILE=/tmp/"${RANDOM}".input.box.txt

$DIALOG --title "Command Input" \
	--default-button "ok" \
	--inputbox "Enter command to continue" \
	10 40 \
	command 2> $TMPFILE

RETVAL=$? #Exit code

USRINPUT=$(cat ${TMPFILE})

$USRINPUT

#TMPFILE=/tmp/${RANDOM}.input.box.txt && dialog --title 'Command Input' --default-button 'ok' --inputbox 'Enter command to continue' 10 40 command 2> ${TMPFILE} && $(cat ${TMPFILE})
