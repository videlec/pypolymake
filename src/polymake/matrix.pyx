###############################################################################
#       Copyright (C) 2011-2012 Burcin Erocal <burcin@erocal.org>
#                     2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from libc.stdlib cimport malloc, free
from cygmp.types cimport mpz_t, mpq_t
from cygmp.mpq cimport *

from defs cimport pm_MatrixRational, pm_Rational, pm_Integer, pm_VectorInteger, get_element

from .number cimport Rational
from number import get_num_den

cdef class MatrixRational:
    def __getitem__(self, elt):
        cdef Py_ssize_t nrows, ncols, i, j
        nrows = self.pm_obj.rows()
        ncols = self.pm_obj.cols()
        i,j = elt
        if not (0 <= i < nrows) or not (0 <= j < ncols):
            raise IndexError("matrix index out of range")

        cdef Rational ans = Rational.__new__(Rational)
        ans.pm_obj.set_mpq_t(get_element(self.pm_obj, i, j).get_rep())
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


def clean_mat(mat):
    r"Return a triple (nr, nc, entries)"
    try:
        nr = mat.nrows()
        nc = mat.ncols()
    except AttributeError:
        if isinstance(mat, (tuple,list)) and mat and \
           all(isinstance(row, (tuple,list)) for row in mat) and mat[0] and \
           all(len(row) == len(mat[0]) for row in mat):
               nr = len(mat)
               nc = len(mat[0])
        else:
            raise ValueError("invalid input {}".format(mat))

    if nr <= 0 or nc <= 0:
        raise ValueError("invalid input {}".format(mat))

    cdef long num, den
    cdef Py_ssize_t i,j
    cdef list clean_mat = []
    cdef list row
    for i in range(nr):
        row = []
        mi = mat[i]
        for j in range(nc):
            row.append(get_num_den(mi[j]))
        clean_mat.append(row)

    return (nr, nc, clean_mat)

cdef pm_MatrixRational* mat_to_pm(int nr, int nc, list mat):
    """
    Create a polymake rational matrix from input so that:

    - there are methods ``nrows``, ``ncols`` giving the number of rows and cols
    - accessing to the elements is done via ``mat[i,j]``
    - given a rational entry we access to numerator and denominator via the
      methods ``.numerator()`` and ``.denominator()``
    """
    # create polymake matrix with dimensions of mat
    cdef pm_MatrixRational* pm_mat = new pm_MatrixRational(nr, nc)

    cdef mpq_t z
    cdef Py_ssize_t i, j
    cdef long num, den

    # clean data
    mpq_init(z)
    for i,row in enumerate(mat):
        for j,(num,den) in enumerate(row):
            mpq_set_si(z, num, den)
            get_element(pm_mat[0], i, j).set_mpq_t(z)
    mpq_clear(z)

    return pm_mat
