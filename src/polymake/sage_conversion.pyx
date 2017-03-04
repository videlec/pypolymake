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

from cygmp.types cimport mpz_t, mpq_t
from cygmp.mpz cimport mpz_set
from cygmp.mpq cimport mpq_set

from .defs cimport mat_int_get_element, mat_integer_get_element, mat_rational_get_element

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

cdef pm_Integer_to_sage(pm_Integer n):
    cdef sage_Integer ans = PY_NEW(sage_Integer)
    ans.set_from_mpz(<mpz_t>n.get_rep())
    return ans

cdef pm_Rational_to_sage(pm_Rational n):
    cdef sage_Rational ans = sage_Rational.__new__(sage_Rational)
    ans.set_from_mpq(<mpq_t>n.get_rep())
    return ans

cdef pm_SetInt_to_sage(pm_SetInt a):
    pass

cdef pm_VectorInteger_to_sage(pm_VectorInteger v):
    V = FreeModule(ZZ, v.size())
    cdef sage_Vector_integer_dense ans = V.zero().__copy__()
    cdef int i
    for i in range(v.size()):
        mpz_set(ans._entries[i], v.get(i).get_rep())
    return ans

cdef pm_VectorRational_to_sage(pm_VectorRational v):
    V = FreeModule(QQ, v.size())
    cdef sage_Vector_rational_dense ans = V.zero().__copy__()
    cdef int i
    for i in range(v.size()):
        mpq_set(ans._entries[i], v.get(i).get_rep())
    return ans

cdef pm_MatrixInt_to_sage(pm_MatrixInt m):
    M = MatrixSpace(ZZ, m.rows(), m.cols())
    cdef sage_Matrix_integer_dense ans = M.zero().__copy__()
    cdef Py_ssize_t i, j
    cdef Py_ssize_t nrows = m.rows()
    cdef Py_ssize_t ncols = m.cols()
    for i in range(nrows):
        for j in range(ncols):
            ans.set_unsafe_si(i, j, mat_int_get_element(m, i, j))
    return ans

cdef pm_MatrixInteger_to_sage(pm_MatrixInteger m):
    M = MatrixSpace(ZZ, m.rows(), m.cols())
    cdef sage_Matrix_integer_dense ans = M.zero().__copy__()
    cdef Py_ssize_t i, j
    cdef Py_ssize_t nrows = m.rows()
    cdef Py_ssize_t ncols = m.cols()
    for i in range(nrows):
        for j in range(ncols):
            ans.set_unsafe_mpz(i, j, <mpz_t> mat_integer_get_element(m, i, j).get_rep())
    return ans

cdef pm_MatrixRational_to_sage(pm_MatrixRational m):
    M = MatrixSpace(QQ, m.rows(), m.cols())
    cdef sage_Matrix_rational_dense ans = M.zero().__copy__()
    cdef Py_ssize_t i, j
    cdef Py_ssize_t nrows = m.rows()
    cdef Py_ssize_t ncols = m.cols()
    for i in range(nrows):
        for j in range(ncols):
            mpq_set(ans._matrix[i][j], <mpq_t> mat_rational_get_element(m, i, j).get_rep())
    return ans
