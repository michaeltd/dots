#!/bin/bash

set -e

if [ $# -ne 2 ]; then
  echo "usage: $0 <base_uri> <target_dir_path>"
  exit 1;
fi

BASE_URI=$1
TARGET_DIR_PATH=$2
INDEX_FILE='index.html'

fetch()
{
  INDEX_URI=$BASE_URI$1
  DIR=`basename $1`

  echo "INDEX_URI=$INDEX_URI"

  if [ ! -d $DIR ]; then
    mkdir $DIR
  fi

  pushd $DIR

  echo "INFO: Downloading $INDEX_URI"
  echo "curl -o $INDEX_FILE -s -L $INDEX_URI"
  curl -o $INDEX_FILE -s -L $INDEX_URI

  if [ $? -eq 0 ]; then
    DIRS=`grep '\[DIR\]' $INDEX_FILE | grep -v 'Parent Directory' | sed -e 's/.*href="\([^"]*\).*/\1/g'`
    TXTS=`grep '\[TXT\]' $INDEX_FILE | sed -e 's/.*href="\([^"]*\).*/\1/g'`
    IMGS=`grep '\[IMG\]' $INDEX_FILE | sed -e 's/.*href="\([^"]*\).*/\1/g'`
    UNKNOWNS=`grep '\[   \]' $INDEX_FILE | sed -e 's/.*href="\([^"]*\).*/\1/g'`

    for FILE in $TXTS $UNKNOWNS $IMGS; do
      FILE_URI=$INDEX_URI$FILE
      echo "INFO: Downloading $FILE_URI"
      curl -O -s -L -R $FILE_URI
      if  [ $? -ne 0 ]; then
        echo "WARN: Failed to download: $FILE_URI" 1>&2
      fi
    done

    for DIR in $DIRS; do
      echo "fetch $1/$DIR"
      fetch $1/$DIR
    done

    rm -f $INDEX_FILE
  else
    echo "WARN: Failed to download directory index: $INDEX_URI" 1>&2
  fi

  popd > /dev/null
}

fetch $TARGET_DIR_PATH
