# distutils: language = c++
# distutils: libraries = polymake
###############################################################################
#       Copyright (C) 2011-2012 Burcin Erocal <burcin@erocal.org>
#                     2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from libcpp.string cimport string

from .defs cimport pm_Integer, pm_Rational

from .integer cimport Integer
from .rational cimport Rational

cdef extern from "polymake/SparseMatrix.h" namespace "polymake":
    # WRAP_CALL(t,i,j) -> t(i,j)
    long pm_SparseMatrixIntNonSymmetric_get "WRAP_CALL" (pm_SparseMatrixIntNonSymmetric, int i, int j)
    pm_Rational pm_SparseMatrixRationalNonSymmetric_get "WRAP_CALL" (pm_SparseMatrixRationalNonSymmetric, int i, int j)

cdef extern from "<sstream>" namespace "std":
    cdef cppclass ostringstream:
        string str()

cdef extern from "wrap.h" namespace "polymake":
    void pm_SparseMatrixIntNonSymmetric_repr "WRAP_wrap_OUT" (ostringstream, pm_SparseMatrixIntNonSymmetric)
    void pm_SparseMatrixRationalNonSymmetric_repr "WRAP_wrap_OUT" (ostringstream, pm_SparseMatrixRationalNonSymmetric)

cdef class SparseMatrixIntNonSymmetric(object):
    def __repr__(self):
        cdef ostringstream out
        pm_SparseMatrixIntNonSymmetric_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')

    def __getitem__(self, elt):
        cdef Py_ssize_t nrows, ncols, i,j
        nrows = self.pm_obj.rows()
        ncols = self.pm_obj.cols()
        i,j = elt
        if not (0 <= i < nrows) or not (0 <= j < ncols):
            raise IndexError("matrix index out of range")

        return pm_SparseMatrixIntNonSymmetric_get(self.pm_obj, i, j)

    def rows(self):
        return self.pm_obj.rows()
    def cols(self):
        return self.pm_obj.cols()

cdef class SparseMatrixRationalNonSymmetric(object):
    def __repr__(self):
        cdef ostringstream out
        pm_SparseMatrixRationalNonSymmetric_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')

    def __getitem__(self, elt):
        cdef Py_ssize_t nrows, ncols, i,j
        nrows = self.pm_obj.rows()
        ncols = self.pm_obj.cols()
        i,j = elt
        if not (0 <= i < nrows) or not (0 <= j < ncols):
            raise IndexError("matrix index out of range")


        cdef Rational ans = Rational.__new__(Rational)
        cdef pm_Rational q = pm_SparseMatrixRationalNonSymmetric_get(self.pm_obj, i, j)
        ans.pm_obj.set_mpq_srcptr(q.get_rep())
        return ans

    def rows(self):
        return self.pm_obj.rows()
    def cols(self):
        return self.pm_obj.cols()


