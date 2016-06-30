pypolymake
==========

This Python module provides wrappers for polymake

    https://polymake.org/doku.php

The language has been kept as close as possible as the original. The
following polymake construction

    polytope> $c = cube(5);
    polytope > print $c->F_VECTOR;
    32 80 80 40 10

is translated in Python as

    >>> from pypolymake import *
    >>> c = cube(5)
    >>> c.F_VECTOR()
    (32, 80, 80, 40, 10)

Authors
-------

This project has been started by Burcin Erocal in 2011 and continued
by Vincent Delecroix in 2016
