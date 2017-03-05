###############################################################################
#       Copyright (C) 2011-2012 Burcin Erocal <burcin@erocal.org>
#                     2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from .defs cimport pm_MatrixRational, pm_assign_MatrixRational, pm_PerlObject, pm_AnyString
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
    cdef pm_AnyString * cprop = new pm_AnyString(prop_name, len(prop_name))
    cdef bytes t = b"Polytope<Rational>"
    cdef pm_AnyString * ct = new pm_AnyString(t, len(t))
    pm.set_application("polytope")
    cdef pm_PerlObject * pm_obj = new pm_PerlObject(ct[0])
    nr, nc, mat = clean_mat(data)
    cdef pm_MatrixRational* pm_mat = rat_mat_to_pm(nr, nc, mat)
    pm_assign_MatrixRational(pm_obj.take(cprop[0]), pm_mat[0])
    del pm_mat

    return wrap_perl_object(pm_obj[0])

