#!/usr/bin/env sh

# run all the tests

if [ "x$NODE" = "x" ]; then
  NODE=node
fi

FILENAME=`which $0`
FILENAME=`"$NODE" -pe "require('fs').realpathSync('$FILENAME')"`
DIR=`dirname "$FILENAME"`

# expose `n8-make` to the PATH
export PATH=$PATH:$DIR/..

TEST_DIRS=$(find "$DIR" -type d -mindepth 1 -maxdepth 1)

for i in $TEST_DIRS; do
  echo testing: $i
  cd "$i"
  n8-make clean
  n8-make build

  # allow for a `test.js` or `test.sh` file per-test
  if [ -f $i/build/test.js ]
  then
    "$NODE" $i/build/test.js
  else
    $i/test.sh
  fi

  cd "$DIR"

  # exit early if the test failed
  EXIT=$?
  if [ $EXIT != 0 ]
  then
    echo "Test failed! Bailing early…"
    exit $EXIT
  fi
done;
