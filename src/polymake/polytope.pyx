###############################################################################
#       Copyright (C) 2011-2012 Burcin Erocal <burcin@erocal.org>
#                     2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from libc.stdlib cimport malloc, free

from defs cimport Main, pm_PerlObject, pm_MatrixRational, pm_Rational, pm_Integer, \
        pm_VectorInteger
from defs cimport CallPolymakeFunction, CallPolymakeFunction1, \
        CallPolymakeFunction2, CallPolymakeFunction3, \
        new_PerlObject_from_PerlObject
from defs cimport pm_get_Integer, pm_get_MatrixRational, pm_get_PerlObject, \
        pm_get_VectorInteger, \
        pm_assign_MatrixRational


from cygmp.types cimport mpz_t, mpq_t
from cygmp.mpq cimport mpq_init, mpq_clear, mpq_set, mpq_set_ui, \
        mpq_set_si, mpq_get_str, mpq_numref, mpq_denref

from .number cimport Integer, Rational
from .vector cimport VectorInteger
from .matrix cimport MatrixRational, mat_to_pm
from .matrix import clean_mat

# FIXME: pass user-settings parameter
cdef Main pm


cdef class PerlObject:
    cdef pm_PerlObject * pm_obj

#    def exists(self, name):
#        if not isinstance(name, (str,unicode)):
#            raise ValueError
#        return self.pm_obj.exists(name)

    def __dealloc__(self):
        del self.pm_obj

    def _get_property(self, prop):
        r"""
        Generic method to get a property of the object
        """
        cdef PerlObject ans = PerlObject.__new__(PerlObject)
        cdef pm_PerlObject o
        pm_get_PerlObject(self.pm_obj.give(prop), o)
        ans.pm_obj = new_PerlObject_from_PerlObject(o)
        return ans

    def _get_bool_property(self, prop):
        r"""
        Get a property as a boolean
        """
        cdef pm_Integer pm_res
        pm_get_Integer(self.pm_obj.give(prop), pm_res)
        return bool(pm_res.compare(0))

    def _get_integer_property(self, prop):
        r"""
        Get a property as a Cython integer
        """
        cdef Integer ans = Integer.__new__(Integer)
        pm_get_Integer(self.pm_obj.give(prop), ans.pm_obj)
        return ans

    def _get_rational_matrix_property(self, prop):
        r"""
        Get a property as a rational matrix
        """
        cdef MatrixRational ans = MatrixRational.__new__(MatrixRational)
        pm_get_MatrixRational(self.pm_obj.give(prop), ans.pm_obj)
        return ans

    def _get_integer_vector_property(self, prop):
        r"""
        Get a property as an integer vector
        """
        cdef VectorInteger ans = VectorInteger.__new__(VectorInteger)
        pm_get_VectorInteger(self.pm_obj.give(prop), ans.pm_obj)
        return ans

    def type_name(self):
        r"""
        Return the name of the type of this object
        """
        return <bytes> self.pm_obj.type().name()

    def __repr__(self):
        return "{}<{}>".format(self.type_name(), hex(id(self)))

cdef class Polytope(PerlObject):
    r"""
    A rational polymake polytope.
    """
    def __init__(self, prop_name, data):
        r"""
        INPUT:

        - ``prop_name`` - either ``'VERTICES'``, ``'POINTS'`` or ``'FACETS'``.

        - ``data`` - matrix with rational entries
        """
        if prop_name not in ['VERTICES', 'POINTS', 'FACETS']:
            raise ValueError("property must be VERTICES, POINTS or FACETS")
        pm.set_application("polytope")
        self.pm_obj = new pm_PerlObject("Polytope<Rational>")
        nr, nc, mat = clean_mat(data)
        cdef pm_MatrixRational* pm_mat = mat_to_pm(nr, nc, mat)
        pm_assign_MatrixRational(self.pm_obj.take(prop_name), pm_mat[0])
        del pm_mat

    def _repr_(self):
        return "Polytope"

    def _save(self, filename):
        """
        Saves this polytope to a file using polymake's representation.
        """
        self.pm_obj.save(filename)

#    #TODO: does not work
#    def AMBIENT_DIM(self):
#        return self._get_integer_property("AMBIENT_DIM")
#
#    #TODO: does not work
#    def DIM(self):
#        return self._get_integer_property("DIM")


    def FACETS(self):
        r"""Return the facets of this polytope as the rows of a matrix

        >>> import polymake
        >>> c = polymake.cube(3)
        >>> c.FACETS()
        [ 1 1  0  0 ]
        [ 1 -1 0  0 ]
        [ 1 0  1  0 ]
        [ 1 0  -1 0 ]
        [ 1 0  0  1 ]
        [ 1 0  0  -1]
        """
        return self._get_rational_matrix_property("FACETS")

#    #TODO: does not work
#    def FULL_DIM(self):
#        return self._get_integer_property("FULL_DIM")

    def F_VECTOR(self):
        r"""Return the f-vector of this polytope

        >>> import polymake
        >>> c = polymake.cube(3)
        >>> c.F_VECTOR()
        (8, 12, 6)
        """
        return self._get_integer_vector_property("F_VECTOR")

    def H_STAR_VECTOR(self):
        r"""Return the h-star vector of this polytope

        >>> import polymake
        >>> c = polymake.cube(4)
        >>> c.H_STAR_VECTOR()
        (1, 76, 230, 76, 1)
        """
        return self._get_integer_vector_property("H_STAR_VECTOR")

    def N_FACETS(self):
        r"""Return the number of facets of this polytope

        >>> import polymake
        >>> c = polymake.birkhoff(4)
        >>> c.N_FACETS()
        16
        """
        return self._get_integer_property("N_FACETS")

#    TODO: does not work
#    def N_POINTS(self):
#        return self._get_integer_property("N_POINTS")

    def N_VERTICES(self):
        r"""Return the number of vertices of this polytope

        >>> import polymake
        >>> c = polymake.dwarfed_cube(4)
        >>> c.N_VERTICES()
        17
        """
        return self._get_integer_property("N_VERTICES")

    def SIMPLE(self):
        r"""Return whether this polytope is simple

        >>> import polymake
        >>> c = polymake.birkhoff(5)
        >>> c.SIMPLE()
        False
        >>> c = polymake.dwarfed_cube(4)
        >>> c.SIMPLE()
        True
        """
        return self._get_bool_property("SIMPLE")

    def SIMPLICIAL(self):
        r"""Return whether this polytope is simplicial

        >>> import polymake
        >>> c = polymake.dwarfed_cube(3)
        >>> c.SIMPLICIAL()
        False
        """
        return self._get_bool_property("SIMPLICIAL")

    def VERTICES(self):
        r"""Return the vertices of this polytope as the rows of a matrix

        >>> import polymake
        >>> c = polymake.cube(3)
        >>> c.VERTICES()
        [ 1 -1 -1 -1]
        [ 1 1  -1 -1]
        [ 1 -1 1  -1]
        [ 1 1  1  -1]
        [ 1 -1 -1 1 ]
        [ 1 1  -1 1 ]
        [ 1 -1 1  1 ]
        [ 1 1  1  1 ]
        """
        return self._get_rational_matrix_property("VERTICES")

#    def graph(self):
#        cdef MatrixRational pm_mat
#        cdef PerlObject *graph = new PerlObject("Graph<Undirected>")
#        pm_get_PerlObject(self.pm_obj.give("GRAPH"), graph[0])
#        pm_get_MatrixRational(graph[0].give("ADJACENCY"), pm_mat)
#        # FIXME: this is broken
#        # FIXME: how do we read the adjacency matrix?
#        return pm_mat_to_sage(pm_mat)

    def visual(self):
        pm.set_preference("jreality")
        self.pm_obj.VoidCallPolymakeMethod("VISUAL")

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
    cdef Polytope res = Polytope.__new__(Polytope)
    res.pm_obj = new_PerlObject_from_PerlObject(pm_obj)
    return res

def associahedron(d):
    r"""Produce a d-dimensional associahedron (or Stasheff polytope)

    >>> import polymake
    >>> a = polymake.associahedron(3)
    >>> a.VERTICES()
    [ 1 1  4  19 1  16]
    [ 1 20 1  4  9  16]
    [ 1 19 4  1  10 16]
    [ 1 16 9  4  1  20]
    [ 1 16 10 1  4  19]
    [ 1 1  20 1  4  18]
    [ 1 1  19 4  1  19]
    [ 1 19 1  10 1  19]
    [ 1 4  1  20 1  16]
    [ 1 4  1  10 16 10]
    [ 1 1  10 1  19 10]
    [ 1 1  4  9  16 10]
    [ 1 10 1  4  19 10]
    [ 1 9  4  1  20 10]
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
    >>> b.VERTICES()
    [ 1 1 0 0 0 1 0 0 0 1]
    [ 1 0 1 0 1 0 0 0 0 1]
    [ 1 0 0 1 1 0 0 0 1 0]
    [ 1 1 0 0 0 0 1 0 1 0]
    [ 1 0 1 0 0 0 1 1 0 0]
    [ 1 0 0 1 0 1 0 1 0 0]
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
    >>> polymake.cube(2).VERTICES()
    [ 1 -1 -1]
    [ 1 1  -1]
    [ 1 -1 1 ]
    [ 1 1  1 ]
    >>> polymake.cube(2,2,0).VERTICES()
    [ 1 0 0]
    [ 1 2 0]
    [ 1 0 2]
    [ 1 2 2]
    """
    return new_Polytope_from_function("cube", d, x_up, x_low)

def cuboctahedron():
    r"""Create cuboctahedron.  An Archimedean solid.

    >>> import polymake
    >>> polymake.cuboctahedron().VERTICES()
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
    >>> polymake.cyclic(2, 4).VERTICES()
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
    >>> polymake.delpezzo(2).VERTICES()
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
    >>> polymake.dwarfed_cube(2).VERTICES()
    [ 1 1   0  ]
    [ 1 1/2 1  ]
    [ 1 1   1/2]
    [ 1 0   1  ]
    [ 1 0   0  ]
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
    >>> p.N_VERTICES()
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

