###############################################################################
#       Copyright (C) 2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from .defs cimport (
        pm_MatrixInt,
        pm_MatrixFloat,
        pm_MatrixInteger,
        pm_MatrixRational,
        pm_SparseMatrixRational)

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

#cdef class SparseMatrixRational(MatrixGeneric):
#    cdef pm_SparseMatrixRational pm_obj

cdef pm_MatrixRational* rat_mat_to_pm(int nr, int nc, list mat)
cdef pm_MatrixInteger* int_mat_to_pm(int nr, int nc, list mat)
