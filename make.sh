#!/usr/bin/env sh

# this wrapper script basically invokes `make` with the Makefile
# in this directory in the context on the current working directory

if [ "x$MAKE" = "x" ]; then
  MAKE=make
fi

# thanks http://stackoverflow.com/a/246128/376773 !
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
export DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

"$MAKE" -f "$DIR/Makefile" "$@"
