# distutils: language = c++
# distutils: libraries = polymake gmp xml2 perl

###############################################################################
#       Copyright (C) 2011-2012 Burcin Erocal <burcin@erocal.org>
#                     2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 2 or any later version.  The full text of the GPL is available at:
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
        pm_assign_MatrixRational, get_element


from cygmp.types cimport mpz_t, mpq_t
from cygmp.mpz cimport mpz_init, mpz_clear, mpz_set, mpz_fits_ulong_p,\
    mpz_fits_slong_p, mpz_get_ui, mpz_get_si, mpz_ptr, mpz_srcptr, mpz_get_str,\
    mpz_sizeinbase
from cygmp.mpq cimport mpq_init, mpq_clear, mpq_set, mpq_set_ui, \
        mpq_set_si, mpq_get_str, mpq_numref, mpq_denref

from .number cimport Integer, Rational
from .vector cimport VectorInteger
from .matrix cimport MatrixRational

# FIXME: pass user-settings parameter
cdef Main pm

cdef pm_MatrixRational* mat_to_pm(mat):
    """
    Create a polymake rational matrix from input so that:
    
    - there are methods ``nrows``, ``ncols`` giving the number of rows and cols
    - accessing to the elements is done via ``mat[i,j]``
    - given a rational entry we access to numerator and denominator via the
      methods ``.numerator()`` and ``.denominator()``
    """
    cdef Py_ssize_t nr = mat.nrows()
    cdef Py_ssize_t nc = mat.ncols()
    cdef mpq_t z
    # create polymake matrix with dimensions of mat
    cdef pm_MatrixRational* pm_mat = new pm_MatrixRational(nr, nc)
    cdef Py_ssize_t i, j
    cdef pm_Rational *tmp_rat
    # loop through the elements and assign values

    cdef long num, den

    mpq_init(z)
    for i in range(nr):
        for j in range(nc):
            elt = mat[i,j]
            try:
                num = elt.numerator()
                den = elt.denominator()
            except AttributeError:
                num = elt
                den = 1
            mpq_set_si(z, num, den)
            get_element(pm_mat[0], i, j).set_mpq_t(z)

    mpq_clear(z)
    return pm_mat

cdef class PerlObject:
    cdef pm_PerlObject * pm_obj

#    def exists(self, name):
#        if not isinstance(name, (str,unicode)):
#            raise ValueError
#        return self.pm_obj.exists(name)

    def __dealloc__(self):
        del self.pm_obj

    def _get_bool_property(self, prop):
        cdef pm_Integer pm_res
        pm_get_Integer(self.pm_obj.give(prop), pm_res)
        return bool(pm_res.compare(0))

    def _get_integer_property(self, prop):
        cdef Integer ans = Integer.__new__(Integer)
        pm_get_Integer(self.pm_obj.give(prop), ans.pm_obj)
        return ans

    def _get_rational_matrix_property(self, prop):
        cdef MatrixRational ans = MatrixRational.__new__(MatrixRational)
        pm_get_MatrixRational(self.pm_obj.give(prop), ans.pm_obj)
        return ans

    def _get_integer_vector_property(self, prop):
        cdef VectorInteger ans = VectorInteger.__new__(VectorInteger)
        pm_get_VectorInteger(self.pm_obj.give(prop), ans.pm_obj)
        return ans

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
        cdef pm_MatrixRational* pm_mat = mat_to_pm(data)
        pm_assign_MatrixRational(self.pm_obj.take(prop_name), pm_mat[0])
        del pm_mat

    def _repr_(self):
        return "Polytope"

    def _save(self, filename):
        """
        Saves this polytope to a file using polymake's representation.
        """
        self.pm_obj.save(filename)

    def __add__(left, right):
        if not (isinstance(left, Polytope) and isinstance(right, Polytope)):
            raise TypeError("both arguments must be instances of Polytope")
        raise NotImplementedError

    #TODO: does not work
    def DIM(self):
        return self._get_integer_property("DIM")

    def FACETS(self):
        return self._get_rational_matrix_property("FACETS")

    #TODO: does not work
    def FULL_DIM(self):
        return self._get_integer_property("FULL_DIM")

    def F_VECTOR(self):
        return self._get_integer_vector_property("F_VECTOR")

    def H_STAR_VECTOR(self):
        return self._get_integer_vector_property("H_STAR_VECTOR")

    def N_FACETS(self):
        return self._get_integer_property("N_FACETS")

    def N_POINTS(self):
        return self._get_integer_property("N_POINTS")

    def N_VERTICES(self):
        return self._get_integer_property("N_VERTICES")

    def SIMPLE(self):
        return self._get_bool_property("SIMPLE")

    def SIMPLICIAL(self):
        return self._get_bool_property("SIMPLICIAL")

    def VERTICES(self):
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
    r"""
    Produce a d-dimensional associahedron (or Stasheff polytope).
    """
    return new_Polytope_from_function("associahedron", d)

def birkhoff(n, even=False):
    """
    Birkhoff polytope
    """
    return new_Polytope_from_function("birkhoff", n, even)

def cube(d, scale=1):
    r"""
    Return a cube of given dimension.  +/-1-coordinates by default.
    """
    return new_Polytope_from_function("cube", d, scale)

def cuboctahedron():
    r"""
    Return the cuboctahedron
    """
    return new_Polytope_from_function("cuboctahedron")

def cyclic_caratheodory(d, n):
    r"""
    Produce a d-dimensional cyclic polytope with n points.
    """
    return new_Polytope_from_function('cyclic_caratheodory', d, n)

def delpezzo(d, scale=1):
    r"""
    Produce a d-dimensional del-Pezzo polytope
    """
    return new_Polytope_from_function("delpezzo", d, scale)

def dwarfed_cube(d):
    r"""
    Produce a d-dimensional dwarfed cube.
    """
    return new_Polytope_from_function("dwarfed_cube", d)

def rand_sphere(dim, npoints):
    """
    Return a random spherical polytope of given dimension and number of points.
    """
    return new_Polytope_from_function("rand_sphere", dim, npoints)



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

