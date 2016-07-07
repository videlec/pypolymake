pypolymake
==========

What is it?
-----------

This Python module provides wrappers for polymake

    https://polymake.org/doku.php

The language has been kept as close as possible as the original. The
following polymake construction::

    polytope> $c = cube(5);
    polytope > print $c->F_VECTOR;
    32 80 80 40 10

is translated in Python as::

    >>> from polymake import *
    >>> c = cube(5)
    >>> c.F_VECTOR()
    (32, 80, 80, 40, 10)

Installation
------------

To install you currently need Sage but the library is mostly Sage agnostic. You
need to download (or clone) this repository and run the command::

    $ sage -python setup.py install --user

(the `--user` argument make the installation in your home)

On OS X, need to make sure that libperl is found:

    $ sage -sh
    (sage-sh) $ export LDFLAGS="-L/System/Library/Perl/5.18/darwin-thread-multi-2level/CORE/ $LDFLAGS"
    (sage-sh) $ python setup.py install --user


It is planned to make it available on pypi as soon as Sage is not needed anymore.

Authors
-------

This project has been started by Burcin Erocal in 2011 and continued
by Vincent Delecroix in 2016
