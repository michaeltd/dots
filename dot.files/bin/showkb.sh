#!/usr/bin/env bash

case "$(xset -q|grep 'LED mask:'| awk '{ print $10 }')" in
  "00000002") KBD="EN" ;;
  "00001002") KBD="EL" ;;
  *) KBD="unknown" ;;
esac

echo $KBD
