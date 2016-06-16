n8-make
=======
### Opinionated Makefile to build ES6 JS, JSX and Pug files

`n8-make` is a wrapper around Make with a Makefile that is
meant to compile JavaScript (and related) files for usage with
Node.js and the web browser.

By default, these file extensions get compiled into the `build` directory:

 * `.js` - Compiled via Babel 6 with support for ES6 and `async` functions
 * `.jsx` - Same as `.js`, but with the `react` preset included as well
 * `.pug` - Pug (a.k.a Jade) lang files get compiled into requireable template functions
 * `.json` - JSON files work as expected


Installation
------------

Install with `npm`:

``` bash
$ npm install --save-dev n8-make
```


Usage
-----

The `n8-make` command invokes the system's `make` with its Makefile.
Any arguments you pass to `n8-make` get passed along to `make`.

The Makefile has a few built-in rules:

#### build (default)

``` bash
$ n8-make
# or
$ n8-make build
```

Compiles all files matching the extensions in the current directory
and nested directories.

A few paths are ignored by default, and will not be compiled:

 * `build` (or whatever `$(BUILDDIR)` get set to)
 * `node_modules`
 * `public`
 * `webpack.config.js`


### clean

``` bash
$ n8-make clean
```

Deletes the `build` directory (or whatever `$(BUILDDIR)` get set to).


### distclean

``` bash
$ n8-make distclean
```

Deletes the `node_modules` directory.


### Custom extensions

For every file that gets compiled, a specialized executable is invoked for each
file extension. For example, given the `.js` file extension, n8-make will invoke
`n8-make-js inputfile.js build/outputfile.js` and the output file is generated
from there.

You may override the default extensions by passing `EXTENSIONS` env to n8-make.
Say you wanted to use n8-make to compile `.coffee` files into js:

``` bash
$ n8-make build EXTENSIONS=coffee
```

But make sure you have a `n8-make-coffee` in your $PATH at this point!

_HINT:_ n8-make inherits npm's `bin` directory, so you can utilize
`devDependencies` in your package.json file to include said executable.


License
-------

(The MIT License)

Copyright (c) 2016 Nathan Rajlich &lt;n@n8.io&gt;

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
