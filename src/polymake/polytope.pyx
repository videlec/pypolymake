###############################################################################
#       Copyright (C) 2011-2012 Burcin Erocal <burcin@erocal.org>
#                     2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from cygmp.types cimport mpz_t, mpq_t
from cygmp.mpq cimport (mpq_init, mpq_clear, mpq_set, mpq_set_ui,
        mpq_set_si, mpq_get_str, mpq_numref, mpq_denref)

from .defs cimport (pm_MatrixRational, pm_assign_MatrixRational,
        pm_PerlObject, new_PerlObject_from_PerlObject, CallPolymakeFunction,
        CallPolymakeFunction1, CallPolymakeFunction2, CallPolymakeFunction3)

from .perl_object cimport PerlObject
from .properties cimport polytope_rational_properties

from .matrix cimport mat_to_pm
from .matrix import clean_mat

# FIXME: pass user-settings parameter
from defs cimport Main
cdef Main pm

def Polytope(prop_name, data):
    r"""
    Construct a polytope

    INPUT:

    - ``prop_name`` - either ``'VERTICES'``, ``'POINTS'`` or ``'FACETS'``.

    - ``data`` - matrix with rational entries
    """
    if prop_name not in ['VERTICES', 'POINTS', 'FACETS']:
        raise ValueError("property must be VERTICES, POINTS or FACETS")
    pm.set_application("polytope")
    cdef pm_PerlObject * pm_obj = new pm_PerlObject("Polytope<Rational>")
    nr, nc, mat = clean_mat(data)
    cdef pm_MatrixRational* pm_mat = mat_to_pm(nr, nc, mat)
    pm_assign_MatrixRational(pm_obj.take(prop_name), pm_mat[0])
    del pm_mat

    cdef PerlObject ans = PerlObject.__new__(PerlObject)
    ans.properties = polytope_rational_properties
    ans.pm_obj = pm_obj
    return ans

# we should wrap all that!

def new_Polytope_from_function(name, *args):
    pm.set_application("polytope")
    cdef pm_PerlObject pm_obj
    if len(args) == 0:
        pm_obj = CallPolymakeFunction(name)
    elif len(args) == 1:
        pm_obj = CallPolymakeFunction1(name, args[0])
    elif len(args) == 2:
        pm_obj = CallPolymakeFunction2(name, args[0], args[1])
    elif len(args) == 3:
        pm_obj = CallPolymakeFunction3(name, args[0], args[1], args[2])
    else:
        raise NotImplementedError("can only handle 1-3 arguments")

    cdef PerlObject ans = PerlObject.__new__(PerlObject)
    ans.pm_obj = new_PerlObject_from_PerlObject(pm_obj)
    ans.properties = polytope_rational_properties
    return ans

def associahedron(d):
    r"""Produce a d-dimensional associahedron (or Stasheff polytope)

    >>> import polymake
    >>> a = polymake.associahedron(3)
    >>> a.N_VERTICES
    14
    """
    return new_Polytope_from_function("associahedron", d)

def birkhoff(n, even=False):
    """Constructs the Birkhoff polytope of dimension `n^2`.

    It is the polytope of `n \\times n` stochastic matrices (encoded as `n^2`
    row vectors), thus matrices with non-negative entries whose row and column
    entries sum up to one. Its vertices are the permutation matrices.

    Keyword arguments:

    n -- integer
    even -- boolean (default to False)

    >>> import polymake
    >>> b = polymake.birkhoff(3)
    >>> b.N_VERTICES
    6
    """
    return new_Polytope_from_function("birkhoff", n, even)

def cube(d, x_up=1, x_low=-1):
    r"""Produce a d-dimensional cube

    Regular polytope corresponding to the Coxeter group of type
    `B^{d-1} = C^{d-1}`.  The bounding hyperplanes are `x_i <= x_{up}` and
    `x_i >= x_{low}`.

    Keyword arguments:

    d -- dimension
    x_up -- upper bound in each dimension
    x_low -- lower bound in each dimension

    >>> import polymake
    >>> polymake.cube(2).VERTICES
    [ 1 -1 -1]
    [ 1 1  -1]
    [ 1 -1 1 ]
    [ 1 1  1 ]
    >>> polymake.cube(2,2,0).VERTICES
    [ 1 0 0]
    [ 1 2 0]
    [ 1 0 2]
    [ 1 2 2]
    """
    return new_Polytope_from_function("cube", d, x_up, x_low)

def cuboctahedron():
    r"""Create cuboctahedron.  An Archimedean solid.

    >>> import polymake
    >>> polymake.cuboctahedron().VERTICES
    [ 1 1  1  0 ]
    [ 1 1  0  1 ]
    [ 1 0  1  1 ]
    [ 1 1  0  -1]
    [ 1 0  1  -1]
    [ 1 1  -1 0 ]
    [ 1 0  -1 1 ]
    [ 1 -1 1  0 ]
    [ 1 -1 0  1 ]
    [ 1 0  -1 -1]
    [ 1 -1 0  -1]
    [ 1 -1 -1 0 ]
    """
    return new_Polytope_from_function("cuboctahedron")

def cyclic(d, n):
    r"""Produce a d-dimensional cyclic polytope with n points.

    Prototypical example of a neighborly polytope. Combinatorics completely
    known due to Gale's evenness criterion. Coordinates are chosen on the
    (spherical) moment curve at integer steps from start, or 0 if unspecified.
    If spherical is true the vertices lie on the sphere with center
    (1/2,0,...,0) and radius 1/2. In this case (the necessarily positive)
    parameter start defaults to 1.

    >>> import polymake
    >>> polymake.cyclic(2, 4).VERTICES
    [ 1 0 0]
    [ 1 1 1]
    [ 1 2 4]
    [ 1 3 9]
    >>> polymake.cyclic(3, 3)
    Traceback (most recent call last):
    ...
    ValueError: cyclic: d >= 2 and n > d required
    <BLANKLINE>
    """
    return new_Polytope_from_function('cyclic', d, n)

def cyclic_caratheodory(d, n):
    r"""Produce a d-dimensional cyclic polytope with n points.

    Prototypical example of a neighborly polytope. Combinatorics completely known
    due to Gale's evenness criterion. Coordinates are chosen on the trigonometric
    moment curve. For cyclic polytopes from other curves, see :func:`cyclic`.
    """
    return new_Polytope_from_function('cyclic_caratheodory', d, n)

def delpezzo(d, scale=1):
    r"""
    Produce a d-dimensional del-Pezzo polytope

    It is the convex hull of the cross polytope together with the all-ones and
    minus all-ones vector. All coordinates are +/- scale or 0.

    Keyword arguments:

    d -- the dimension
    scale -- the absolute value of each non-zero vertex coordinate.

    >>> import polymake
    >>> polymake.delpezzo(2).VERTICES
    [ 1 1  0 ]
    [ 1 0  1 ]
    [ 1 -1 0 ]
    [ 1 0  -1]
    [ 1 1  1 ]
    [ 1 -1 -1]
    """
    return new_Polytope_from_function("delpezzo", d, scale)

def dwarfed_cube(d):
    r"""Produce a d-dimensional dwarfed cube.

    Keyword arguments:

    d -- the dimension

    >>> import polymake
    >>> polymake.dwarfed_cube(2).N_VERTICES
    5
    """
    return new_Polytope_from_function("dwarfed_cube", d)

def rand_sphere(dim, npoints):
    r"""Produce a d-dimensional polytope with n random vertices uniformly
    distributed on the unit sphere.

    Keyword arguments:

    d -- the dimension
    n -- the number of random vertices

    >>> import polymake
    >>> p = polymake.rand_sphere(3, 10)
    >>> p.N_VERTICES
    10
    """
    return new_Polytope_from_function("rand_sphere", dim, npoints)


##########################################
# TODO for more support

def dodecahedron():
    r"""
    Create exact regular dodecahedron in Q(sqrt{5}).  A Platonic solid.

    Polytope__QuadraticExtension__Rational
    """
    raise NotImplementedError("THIS IS NOT A RATIONAL POLYTOPE")

def icosahedron():
    r"""
    Create exact regular icosahedron in Q(sqrt{5}).  A Platonic solid.

    Polytope__QuadraticExtension__Rational
    """
    raise NotImplementedError("THIS IS NOT A RATIONAL POLYTOPE")

def archimedean_solid(s):
    raise NotImplementedError

def catalan_solid(s):
    raise NotImplementedError

