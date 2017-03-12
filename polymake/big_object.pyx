# distutils: language = c++
# distutils: libraries = polymake
###############################################################################
#       Copyright (C) 2011-2012 Burcin Erocal <burcin@erocal.org>
#                     2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from .cygmp.mpz cimport *
from .cygmp.mpz cimport *
from .defs cimport (pm_Integer, pm_Rational, pm_MatrixInteger, pm_MatrixRational,
        pm_assign_MatrixRational, pm_PerlObject)
from .perl_object cimport wrap_perl_object
from .rational import get_num_den

cdef extern from "polymake/Matrix.h" namespace "polymake":
    # WRAP_CALL(t,i,j) -> t(i,j)
    pm_Integer pm_MatrixInteger_get "WRAP_CALL" (pm_MatrixInteger, int i, int j)
    pm_Rational pm_MatrixRational_get "WRAP_CALL" (pm_MatrixRational, int i, int j)

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

cdef pm_MatrixRational* rat_mat_to_pm(int nr, int nc, list mat):
    """
    Create a polymake rational matrix from input so that:

    - accessing to the elements is done via ``mat[i,j]``
    - given a rational entry we access to numerator and denominator via the
      methods ``.numerator()`` and ``.denominator()``
    """
    # create polymake matrix with dimensions of mat
    cdef pm_MatrixRational* pm_mat = new pm_MatrixRational(nr, nc)

    cdef Py_ssize_t i, j
    cdef long num, den

    # clean data
    for i,row in enumerate(mat):
        for j,elt in enumerate(row):
            num, den = get_num_den(elt)
            pm_MatrixRational_get(pm_mat[0], i, j).set_long(num, den)

    return pm_mat

cdef pm_MatrixInteger* int_mat_to_pm(int nr, int nc, list mat):
    """
    Create a polymake integer matrix from input so that:

    - there are methods ``nrows``, ``ncols`` giving the number of rows and cols
    - accessing to the elements is done via ``mat[i,j]``
    """
    # create polymake matrix with dimensions of mat
    cdef pm_MatrixInteger* pm_mat = new pm_MatrixInteger(nr, nc)

    cdef mpz_t z
    cdef Py_ssize_t i, j

    # clean data
    mpz_init(z)
    for i,row in enumerate(mat):
        for j,elt in enumerate(row):
            mpz_set_si(z, elt)
            pm_MatrixInteger_get(pm_mat[0], i, j).set_mpz_srcptr(z)
    mpz_clear(z)

    return pm_mat

def Polytope(**args):
    r"""
    Construct a polytope

    INPUT:

    - ``VERTICES`` -- a matrix of vertices

    - ``POINTS`` -- a matrix of points

    - ``FACETS`` -- a matrix of facets

    EXAMPLES:

    >>> 
    """
    cdef pm_MatrixRational * pm_mat
    # FIXME: this should not be needed
    from .main import pm_set_application
    pm_set_application(b"polytope")

    cdef pm_PerlObject * pm_obj = new pm_PerlObject(b"Polytope<Rational>")

    for prop, value in args.items():
        if prop not in ['VERTICES', 'POINTS', 'FACETS']:
            raise ValueError("property must be VERTICES, POINTS or FACETS")

        prop = prop.encode('ascii')

        nr, nc, mat = clean_mat(value)
        pm_mat = rat_mat_to_pm(nr, nc, mat)
        pm_assign_MatrixRational(pm_obj.take(prop), pm_mat[0])
        del pm_mat

    return wrap_perl_object(pm_obj[0])

