# distutils: language = c++
# distutils: libraries = polymake
r"""
Polymake matrices

This file contains wrappers for polymake matrices

- Matrix
- SparseMatrix
- IncidenceMatrix

EXAMPLES::

>>> import polymake
>>> c = polymake.associahedron(3)

>>> m1 = c.AFFINE_HULL
>>> m1
-150 1 2 3 4 5
106/11 -34/11 -46/11 -36/11 -4/11 50/11
>>> type(m1)
polymake.matrix.MatrixRational
>>> e = m1[1,2]
>>> e, type(e)
(-46/11, polymake.number.Rational)
>>> m1.python()
[[Fraction(-150, 1), Fraction(1, 1), Fraction(2, 1), Fraction(3, 1), Fraction(4, 1), Fraction(5, 1)],
 [Fraction(106, 11), Fraction(-34, 11), Fraction(-46, 11), Fraction(-36, 11), Fraction(-4, 11), Fraction(50, 11)]]

>>> m2 = c.COCIRCUIT_EQUATIONS
>>> m2
(946) (0 1) (1 1) (2 1) (3 1) (4 1) (5 -1) (6 -1) (7 -1) (8 -1) (9 -1)
(946) (0 -1) (10 -1) (11 -1) (12 -1) (13 1) (14 1) (15 -1) (16 -1) (17 -1) (18 -1) (19 -1)
...
(946) (260 -1) (466 1) (622 1) (738 1) (819 1) (873 1) (906 1) (925 1) (941 -1) (944 -1) (945 -1)
>>> type(m2)
polymake.matrix.SparseMatrixRationalNonSymmetric
>>> e = m2[1,10]
>>> e, type(e)
(-1, polymake.number.Rational)

>>> m3 = c.DEGREE_ONE_GENERATORS
>>> m3
1 1 4 9 16 10
1 1 4 19 1 16
...
1 20 1 4 9 16
>>> type(m3)
polymake.matrix.MatrixInteger
>>> e = m3[5, 2]
>>> e,type(e)
(8, polymake.number.Integer)

>>> m4 = c.VERTICES_IN_FACETS
>>> m4
{0 5 6 10 11}
{0 8 9 11}
...
{0 3 6 7 8}
>>> type(m4)
polymake.matrix.IncidenceMatrixNonSymmetric
>>> m4[0,2], m4[0,5]
(False, True)
"""
###############################################################################
#       Copyright (C) 2011-2012 Burcin Erocal <burcin@erocal.org>
#                     2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from libcpp cimport bool
from libcpp.string cimport string

include "auto_matrix.pxi"

from libc.stdlib cimport malloc, free
from .cygmp.types cimport mpz_t, mpq_t, mpz_srcptr, mpq_srcptr
from .cygmp.mpz cimport *
from .cygmp.mpq cimport *

from .defs cimport pm_Integer, pm_Rational

from .integer cimport Integer
from .rational cimport Rational


cdef extern from "polymake/Matrix.h" namespace "polymake":
    # WRAP_CALL(t,i,j) -> t(i,j)
    long pm_MatrixInt_get "WRAP_CALL" (pm_MatrixInt, int i, int j)
    float pm_MatrixFloat_get "WRAP_CALL" (pm_MatrixFloat, int i, int j)
    pm_Integer pm_MatrixInteger_get "WRAP_CALL" (pm_MatrixInteger, int i, int j)
    pm_Rational pm_MatrixRational_get "WRAP_CALL" (pm_MatrixRational, int i, int j)
    pm_QuadraticExtensionRational_get "WRAP_CALL" (pm_MatrixQuadraticExtensionRational, int i, int j)

#cdef extern from "polymake/SparseMatrix.h" namespace "polymake":
#    # WRAP_CALL(t,i,j) -> t(i,j)
#    long pm_SparseMatrixIntNonSymmetric_get "WRAP_CALL" (pm_SparseMatrixIntNonSymmetric, int i, int j)
#    pm_Rational pm_SparseMatrixRationalNonSymmetric_get "WRAP_CALL" (pm_SparseMatrixRationalNonSymmetric, int i, int j)

cdef extern from "<sstream>" namespace "std":
    cdef cppclass ostringstream:
        string str()

cdef extern from "wrap.h" namespace "polymake":
    void pm_MatrixInt_repr "WRAP_wrap_OUT" (ostringstream, pm_MatrixInt)
    void pm_MatrixFloat_repr "WRAP_wrap_OUT" (ostringstream, pm_MatrixFloat)
    void pm_MatrixInteger_repr "WRAP_wrap_OUT" (ostringstream, pm_MatrixInteger)
    void pm_MatrixRational_repr "WRAP_wrap_OUT" (ostringstream, pm_MatrixRational)

#    def python(self):
#        r"""Converts to a list of list of fractions
#
#        >>> import polymake
#
#        >>> c = polymake.cube(3)
#        >>> m = c.DEGREE_ONE_GENERATORS.python()
#        >>> m
#        [[1, -1, -1, -1],
#         [1, -1, -1, 0],
#         [1, -1, -1, 1],
#        ...
#         [1, 1, 1, 0],
#         [1, 1, 1, 1]]
#        >>> type(m), type(m[0]), type(m[0][0])
#        (<type 'list'>, <type 'list'>, <type 'int'>)
#
#        >>> c = polymake.cube(3)
#        >>> m = c.VERTEX_NORMALS.python()
#        >>> m
#        [[Fraction(1, 2), Fraction(1, 2), Fraction(1, 2), Fraction(1, 2)],
#         [Fraction(1, 2), Fraction(-1, 2), Fraction(1, 2), Fraction(1, 2)],
#         [Fraction(1, 2), Fraction(1, 2), Fraction(-1, 2), Fraction(1, 2)],
#        ...
#         [Fraction(1, 2), Fraction(1, 2), Fraction(-1, 2), Fraction(-1, 2)],
#         [Fraction(1, 2), Fraction(-1, 2), Fraction(-1, 2), Fraction(-1, 2)]]
#
#        >>> c = polymake.cube(3)
#        >>> m = c.EDGE_ORIENTATION.python()
#        [[0, 4],
#         [2, 6],
#         [0, 2],
#         ...
#         [2, 3],
#         [6, 7]]
#        >>> type(m), type(m[0]), type(m[0][0])
#        (<type 'list'>, <type 'list'>, <type 'int'>)
#        """
#        cdef Py_ssize_t i, j, nrows, ncols
#        nrows = self.rows()
#        ncols = self.cols()
#        try:
#            return [[self[i,j].python() for j in range(ncols)] for i in range(nrows)]
#        except AttributeError:
#            return [[self[i,j] for j in range(ncols)] for i in range(nrows)]

cdef class MatrixInt(object):
    def __repr__(self):
        cdef ostringstream out
        pm_MatrixInt_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')

    def __getitem__(self, elt):
        cdef Py_ssize_t nrows, ncols, i,j
        nrows = self.pm_obj.rows()
        ncols = self.pm_obj.cols()
        i,j = elt
        if not (0 <= i < nrows) or not (0 <= j < ncols):
            raise IndexError("matrix index out of range")

        return pm_MatrixInt_get(self.pm_obj, i, j)

    def rows(self):
        return self.pm_obj.rows()
    def cols(self):
        return self.pm_obj.cols()

    def sage(self):
        r"""Converts into a Sage matrix

        >>> import polymake
        >>> c = polymake.cube(3)
        >>> m = c.EDGE_ORIENTATION
        >>> m.sage()
        [0 4]
        [2 6]
        [0 2]
        ...
        [2 3]
        [6 7]
        >>> type(m.sage())
        <type 'sage.matrix.matrix_integer_dense.Matrix_integer_dense'>
        """
        from .sage_conversion import MatrixInt_to_sage
        return MatrixInt_to_sage(self)

cdef class MatrixFloat(object):
    def __repr__(self):
        cdef ostringstream out
        pm_MatrixFloat_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')

    def __getitem__(self, elt):
        cdef Py_ssize_t nrows, ncols, i,j
        nrows = self.pm_obj.rows()
        ncols = self.pm_obj.cols()
        i,j = elt
        if not (0 <= i < nrows) or not (0 <= j < ncols):
            raise IndexError("matrix index out of range")

        return pm_MatrixFloat_get(self.pm_obj, i, j)

    def rows(self):
        return self.pm_obj.rows()
    def cols(self):
        return self.pm_obj.cols()

cdef class MatrixInteger(object):
    def __repr__(self):
        cdef ostringstream out
        pm_MatrixInteger_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')

    def __getitem__(self, elt):
        cdef Py_ssize_t nrows, ncols, i,j
        nrows = self.pm_obj.rows()
        ncols = self.pm_obj.cols()
        i,j = elt
        if not (0 <= i < nrows) or not (0 <= j < ncols):
            raise IndexError("matrix index out of range")

        cdef Integer ans = Integer.__new__(Integer)
        ans.pm_obj.set_mpz_srcptr(pm_MatrixInteger_get(self.pm_obj, i, j).get_rep())
        return ans

    def rows(self):
        return self.pm_obj.rows()
    def cols(self):
        return self.pm_obj.cols()

    def sage(self):
        r"""Converts to a Sage integer matrix

        >>> import polymake
        >>> c = polymake.cube(3)
        >>> m = c.DEGREE_ONE_GENERATORS
        >>> m
        [ 1 -1 -1 -1]
        [ 1 -1 -1 0 ]
        [ 1 -1 -1 1 ]
        ...
        [ 1 1  1  -1]
        [ 1 1  1  0 ]
        [ 1 1  1  1 ]
        >>> s = m.sage()
        >>> s
        27 x 4 dense matrix over Integer Ring
        >>> print s.str()
        [ 1 -1 -1 -1]
        [ 1 -1 -1  0]
        [ 1 -1 -1  1]
        ...
        [ 1  1  1 -1]
        [ 1  1  1  0]
        [ 1  1  1  1]
        >>> type(s)
        <type 'sage.matrix.matrix_integer_dense.Matrix_integer_dense'>
        """
        from .sage_conversion import MatrixInteger_to_sage
        return MatrixInteger_to_sage(self)


cdef class MatrixRational(object):
    def __repr__(self):
        cdef ostringstream out
        pm_MatrixRational_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')

    def __getitem__(self, elt):
        cdef Py_ssize_t nrows, ncols, i, j
        nrows = self.pm_obj.rows()
        ncols = self.pm_obj.cols()
        i,j = elt
        if not (0 <= i < nrows) or not (0 <= j < ncols):
            raise IndexError("matrix index out of range")

        cdef Rational ans = Rational.__new__(Rational)
        cdef mpq_srcptr q = pm_MatrixRational_get(self.pm_obj, i, j).get_rep()
        ans.pm_obj.set_mpq_srcptr(q)
        return ans

    def rows(self):
        return self.pm_obj.rows()
    def cols(self):
        return self.pm_obj.cols()

    def sage(self):
        r"""Converts into a Sage matrix

        >>> import polymake
        >>> c = polymake.cube(3)
        >>> m = c.VERTEX_NORMALS.sage()
        >>> m
        [ 1/2  1/2  1/2  1/2]
        [ 1/2 -1/2  1/2  1/2]
        [ 1/2  1/2 -1/2  1/2]
        ...
        [ 1/2 -1/2 -1/2 -1/2]
        >>> type(m)
        <type 'sage.matrix.matrix_rational_dense.Matrix_rational_dense'>
        """
        from .sage_conversion import MatrixRational_to_sage
        return MatrixRational_to_sage(self)


