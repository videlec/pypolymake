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

from .number cimport Rational

cdef class MatrixRational:
    def __getitem__(self, elt):
        cdef Py_ssize_t nrows, ncols, i, j
        nrows = self.pm_obj.rows()
        ncols = self.pm_obj.cols()
        i,j = elt
        if not (0 <= i < nrows) or not (0 <= j < ncols):
            raise IndexError("matrix index out of range")

        cdef Rational ans = Rational.__new__(Rational)
        ans.pm_obj.set_mpq_t(get_element(self.pm_obj, i,j ).get_rep())
        return ans

    def __repr__(self):
        cdef Py_ssize_t nrows, ncols, i, j
        nrows = self.pm_obj.rows()
        ncols = self.pm_obj.cols()

        rows = [[str(self[i,j]) for j in range(ncols)] for i in range(nrows)]
        col_sizes = [max(len(rows[i][j]) for i in range(nrows)) for j in range(ncols)]

        line_format = "[ " +  \
                " ".join("{{:{width}}}".format(width=t) for t in col_sizes) + \
                      "]"
        
        return "\n".join(line_format.format(*row) for row in rows)

