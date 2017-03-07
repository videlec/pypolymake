# distutils: language = c++
# distutils: libraries = gmp polymake
###############################################################################
#       Copyright (C) 2011-2012 Burcin Erocal <burcin@erocal.org>
#                     2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from .defs cimport pm_MatrixRational, pm_assign_MatrixRational, pm_PerlObject
from .perl_object cimport wrap_perl_object, pm
from .matrix cimport rat_mat_to_pm
from .matrix import clean_mat

def Polytope(bytes prop_name, data):
    r"""
    Construct a polytope

    INPUT:

    - ``prop_name`` - either ``'VERTICES'``, ``'POINTS'`` or ``'FACETS'``.

    - ``data`` - matrix with rational entries
    """
    if prop_name not in ['VERTICES', 'POINTS', 'FACETS']:
        raise ValueError("property must be VERTICES, POINTS or FACETS")
    pm.set_application("polytope")
    cdef pm_PerlObject * pm_obj = new pm_PerlObject(b"Polytope<Rational>")
    nr, nc, mat = clean_mat(data)
    cdef pm_MatrixRational* pm_mat = rat_mat_to_pm(nr, nc, mat)
    pm_assign_MatrixRational(pm_obj.take(prop_name), pm_mat[0])
    del pm_mat

    return wrap_perl_object(pm_obj[0])

