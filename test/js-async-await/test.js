import assert from 'assert';
import asyncFn from './';

function isThenable (val) {
  return val && 'function' === typeof val.then;
}

// rethrow unhandled promise errors (for assert())
process.on('unhandledRejection', (err) => {
  throw err;
});

const promise = asyncFn(42);

assert(isThenable(promise));

let called = false;
promise.then((rtn) => {
  called = true;
  assert.equal(rtn, 84);
});
process.on('exit', () => {
  assert(called);
});
