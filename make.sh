#!/usr/bin/env sh

# this wrapper script basically invokes `make` with the Makefile
# in this directory in the context on the current working directory

if [ "x$MAKE" = "x" ]; then
  MAKE=make
fi

# thanks http://stackoverflow.com/a/8506790/376773 !
export DIR=$( cd $( dirname -- "$0" ) > /dev/null ; pwd )

"$MAKE" -f "$DIR/Makefile" "$@"
