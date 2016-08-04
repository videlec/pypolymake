###############################################################################
#       Copyright (C) 2011-2012 Burcin Erocal <burcin@erocal.org>
#                     2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from cygmp.types cimport mpz_t, mpq_t
from cygmp.mpq cimport (mpq_init, mpq_clear, mpq_set, mpq_set_ui,
        mpq_set_si, mpq_get_str, mpq_numref, mpq_denref)

from .defs cimport (pm_MatrixRational, pm_assign_MatrixRational,
        pm_PerlObject, new_PerlObject_from_PerlObject, CallPolymakeFunction,
        CallPolymakeFunction1, CallPolymakeFunction2, CallPolymakeFunction3)

from .perl_object cimport PerlObject, wrap_perl_object
from .perl_object import call_polymake_function
from .properties cimport type_properties, pm_type_polytope_rational

from .matrix cimport mat_to_pm
from .matrix import clean_mat

# FIXME: pass user-settings parameter
from .defs cimport Main
cdef Main pm

def Polytope(prop_name, data):
    r"""
    Construct a polytope

    INPUT:

    - ``prop_name`` - either ``'VERTICES'``, ``'POINTS'`` or ``'FACETS'``.

    - ``data`` - matrix with rational entries
    """
    if prop_name not in ['VERTICES', 'POINTS', 'FACETS']:
        raise ValueError("property must be VERTICES, POINTS or FACETS")
    pm.set_application("polytope")
    cdef pm_PerlObject * pm_obj = new pm_PerlObject("Polytope<Rational>")
    nr, nc, mat = clean_mat(data)
    cdef pm_MatrixRational* pm_mat = mat_to_pm(nr, nc, mat)
    pm_assign_MatrixRational(pm_obj.take(prop_name), pm_mat[0])
    del pm_mat

    return wrap_perl_object(pm_obj[0])

# we should wrap all that!


##########################################
# TODO for more support


def archimedean_solid(s):
    raise NotImplementedError

def catalan_solid(s):
    raise NotImplementedError

