#!/bin/bash

DIALOG=${1-"Xdialog"}

TMPFILE="/tmp/input.box.txt"

$DIALOG --title "Command Input" \
	--inputbox "Enter command to continue" \
	10 40 \
	command 2> $TMPFILE

RETVAL=$? #Exit code

USRINPUT=$(cat ${TMPFILE})

$USRINPUT
