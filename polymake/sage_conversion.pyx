# distutils: language = c++
# distutils: libraries = polymake
r"""
Conversion of low level base types to Sage
"""
###############################################################################
#       Copyright (C) 2017      Vincent Delecroix <vincent.delecroix@labri.fr> 
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from __future__ import absolute_import

from .number cimport Integer, Rational
from .vector cimport VectorInteger, VectorRational
from .matrix cimport (MatrixInt, MatrixInteger, MatrixRational,
                    pm_MatrixInt_get, pm_MatrixInteger_get, pm_MatrixRational_get)

from .cygmp.types cimport mpz_t, mpq_t
from .cygmp.mpz cimport mpz_set
from .cygmp.mpq cimport mpq_set

from sage.ext.stdsage cimport PY_NEW

from sage.rings.integer_ring import ZZ
from sage.rings.rational_field import QQ
from sage.modules.free_module import FreeModule
from sage.matrix.matrix_space import MatrixSpace

from sage.structure.parent cimport Parent

from sage.rings.integer cimport Integer as sage_Integer
from sage.rings.rational cimport Rational as sage_Rational
from sage.modules.vector_integer_dense cimport Vector_integer_dense as sage_Vector_integer_dense
from sage.modules.vector_rational_dense cimport Vector_rational_dense as sage_Vector_rational_dense
from sage.matrix.matrix_rational_dense cimport Matrix_rational_dense as sage_Matrix_rational_dense
from sage.matrix.matrix_integer_dense cimport Matrix_integer_dense as sage_Matrix_integer_dense

def Integer_to_sage(Integer n):
    cdef sage_Integer ans = PY_NEW(sage_Integer)
    ans.set_from_mpz(<mpz_t>n.pm_obj.get_rep())
    return ans

def Rational_to_sage(Rational q):
    cdef sage_Rational ans = sage_Rational.__new__(sage_Rational)
    ans.set_from_mpq(<mpq_t>q.pm_obj.get_rep())
    return ans

#def SetInt_to_sage(SetInt a):
#    pass

def VectorInteger_to_sage(VectorInteger v):
    V = FreeModule(ZZ, v.size())
    cdef sage_Vector_integer_dense ans = V.zero().__copy__()
    cdef int i
    for i in range(v.size()):
        mpz_set(ans._entries[i], v.pm_obj.get(i).get_rep())
    return ans

def VectorRational_to_sage(VectorRational v):
    V = FreeModule(QQ, v.size())
    cdef sage_Vector_rational_dense ans = V.zero().__copy__()
    cdef int i
    for i in range(v.size()):
        mpq_set(ans._entries[i], v.pm_obj.get(i).get_rep())
    return ans

def MatrixInt_to_sage(MatrixInt m):
    cdef Py_ssize_t i, j
    cdef Py_ssize_t nrows = m.pm_obj.rows()
    cdef Py_ssize_t ncols = m.pm_obj.cols()
    M = MatrixSpace(ZZ, nrows, ncols)
    cdef sage_Matrix_integer_dense ans = M.zero().__copy__()
    for i in range(nrows):
        for j in range(ncols):
            ans.set_unsafe_si(i, j, pm_MatrixInt_get(m.pm_obj, i, j))
    return ans

def MatrixInteger_to_sage(MatrixInteger m):
    cdef Py_ssize_t i, j
    cdef Py_ssize_t nrows = m.pm_obj.rows()
    cdef Py_ssize_t ncols = m.pm_obj.cols()
    M = MatrixSpace(ZZ, nrows, ncols)
    cdef sage_Matrix_integer_dense ans = M.zero().__copy__()
    for i in range(nrows):
        for j in range(ncols):
            ans.set_unsafe_mpz(i, j, <mpz_t> pm_MatrixInteger_get(m.pm_obj, i, j).get_rep())
    return ans

def MatrixRational_to_sage(MatrixRational m):
    cdef Py_ssize_t i, j
    cdef Py_ssize_t nrows = m.pm_obj.rows()
    cdef Py_ssize_t ncols = m.pm_obj.cols()
    M = MatrixSpace(QQ, nrows, ncols)
    cdef sage_Matrix_rational_dense ans = M.zero().__copy__()
    for i in range(nrows):
        for j in range(ncols):
            mpq_set(ans._matrix[i][j], <mpq_t> pm_MatrixRational_get(m.pm_obj, i, j).get_rep())
    return ans
