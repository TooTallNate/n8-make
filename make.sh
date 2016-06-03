#!/usr/bin/env sh

# this wrapper script basically invokes `make` with the Makefile
# in this directory in the context of the current working directory

if [ "x$MAKE" = "x" ]; then
  MAKE=make
fi
if [ "x$NODE" = "x" ]; then
  NODE=node
fi

FILENAME=`which $0`
FILENAME=`"$NODE" -pe "require('fs').realpathSync('$FILENAME')"`
export DIR=`dirname "$FILENAME"`

"$MAKE" -f "$DIR/Makefile" "$@"
