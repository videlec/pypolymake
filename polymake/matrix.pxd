###############################################################################
#       Copyright (C) 2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from .defs cimport pm_MatrixRational, pm_MatrixInteger, pm_MatrixInt

cdef class MatrixRational:
    cdef pm_MatrixRational pm_obj
cdef class MatrixInteger:
    cdef pm_MatrixInteger pm_obj
cdef class MatrixInt:
    cdef pm_MatrixInt pm_obj

cdef pm_MatrixRational* rat_mat_to_pm(int nr, int nc, list mat)
cdef pm_MatrixInteger* int_mat_to_pm(int nr, int nc, list mat)
cdef pm_MatrixInt* i_mat_to_pm(int nr, int nc, list mat)
