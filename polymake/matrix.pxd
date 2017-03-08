###############################################################################
#       Copyright (C) 2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from .defs cimport (
        pm_Integer, pm_Rational,
        pm_MatrixInt,
        pm_MatrixFloat,
        pm_MatrixInteger,
        pm_MatrixRational,
        pm_SparseMatrixIntNonSymmetric,
        pm_SparseMatrixRationalNonSymmetric,
        pm_IncidenceMatrixNonSymmetric)

cdef extern from "polymake/Matrix.h" namespace "polymake":
    # WRAP_CALL(t,i,j) -> t(i,j)
    long pm_MatrixInt_get "WRAP_CALL" (pm_MatrixInt, int i, int j)
    float pm_MatrixFloat_get "WRAP_CALL" (pm_MatrixFloat, int i, int j)
    pm_Rational pm_MatrixRational_get "WRAP_CALL" (pm_MatrixRational, int i, int j)
    pm_Integer pm_MatrixInteger_get "WRAP_CALL" (pm_MatrixInteger, int i, int j)

cdef extern from "polymake/SparseMatrix.h" namespace "polymake":
    # WRAP_CALL(t,i,j) -> t(i,j)
    long pm_SparseMatrixIntNonSymmetric_get "WRAP_CALL" (pm_SparseMatrixIntNonSymmetric, int i, int j)
    pm_Rational pm_SparseMatrixRationalNonSymmetric_get "WRAP_CALL" (pm_SparseMatrixRationalNonSymmetric, int i, int j)

cdef extern from "polymake/IncidenceMatrix.h" namespace "polymake":
    bint pm_IncidenceMatrixNonSymmetric_get "WRAP_CALL" (pm_IncidenceMatrixNonSymmetric, int i, int j)

cdef class MatrixGeneric(object):
    cpdef Py_ssize_t rows(self)
    cpdef Py_ssize_t cols(self)

cdef class MatrixInt(MatrixGeneric):
    cdef pm_MatrixInt pm_obj
cdef class MatrixFloat(MatrixGeneric):
    cdef pm_MatrixFloat pm_obj

cdef class MatrixInteger(MatrixGeneric):
    cdef pm_MatrixInteger pm_obj
cdef class MatrixRational(MatrixGeneric):
    cdef pm_MatrixRational pm_obj

cdef class SparseMatrixIntNonSymmetric(MatrixGeneric):
    cdef pm_SparseMatrixIntNonSymmetric pm_obj
cdef class SparseMatrixRationalNonSymmetric(MatrixGeneric):
    cdef pm_SparseMatrixRationalNonSymmetric pm_obj

cdef class IncidenceMatrixNonSymmetric(MatrixGeneric):
    cdef pm_IncidenceMatrixNonSymmetric pm_obj

cdef pm_MatrixRational* rat_mat_to_pm(int nr, int nc, list mat)
cdef pm_MatrixInteger* int_mat_to_pm(int nr, int nc, list mat)
