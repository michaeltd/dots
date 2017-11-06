#!/bin/bash
# Use -gt 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use -gt 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --default example).
# note: if this is set to -gt 0 the /etc/hosts part is not recognized ( may be a bug )

EXTENSION=".desktop"

HEADER="[Desktop Entry]"

TYPE="Application"
ENCOD="Encoding=UTF-8"
NAME="Name="
COMMNT="Comment="
EXEC="Exec="
ICON="Icon="
TERM="Terminal="
CAT="Categories=Other;"


while [[ $# -gt 1 ]]; do
  key="$1"

  case $key in
      -n|--name)
        NAME="$NAME$2"
        shift # past argument
      ;;
      -c|--comment)
        COMMNT="$COMMNT$2"
        shift # past argument
      ;;
      -e|--exec)
        EXEC="$EXEC$2"
        shift # past argument
      ;;
      -i|--icon)
        ICON="$ICON$2"
        shift # past argument
      ;;
      -t|--term)
        TERM="$TERM$2"
        shift # past argument
      ;;
      -g|--group)
        CAT="$CAT$2"
        shift # past argument
      ;;
      *)
        # unknown option
      ;;
  esac
  shift # past argument or value
done

FN="~/.local/share/applications/$NAME$EXTENSION"

#touch $FN

echo $HEADER \n $TYPE \n $ENCOD \n $NAME \n $COMMNT \n $EXEC \n $ICON \n $TERM \n $CAT >> $FN
