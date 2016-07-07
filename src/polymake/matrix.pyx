###############################################################################
#       Copyright (C) 2011-2012 Burcin Erocal <burcin@erocal.org>
#                     2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 2 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from libc.stdlib cimport malloc, free
from cygmp.types cimport mpz_t, mpq_t
from cygmp.mpq cimport *

from defs cimport pm_MatrixRational, pm_Rational, pm_Integer, pm_VectorInteger, get_element

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

