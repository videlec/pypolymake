# distutils: language = c++
# distutils: libraries = gmp polymake
r"""
Structure of polymake objects and mapping to Python objects

Up to now we registered around 20 polymake types (e.g. "bool", "int",
"Vector<Integer>", etc). To each objects is attached a list of properties that
are hardcoded in dictionaries. The keys in the dictionary are the property names
and the values are the type of the property.

To each type is associated a handler that will build the corresponding Python
object. The generic one is just a generic wrapper over perl object. This can be
overriden (e.g. you might want integer properties to output integers from gmpy).

.. TODO::

    Ideally the structure of polymake objects should be computed dynamically...
    However, it is not easy to achieve. In the interactive polymake shell one can
    just run through the help system

    polytope > help "objects/Cone/properties";
    Categories of objects/Cone/properties:
    Combinatorics, Geometry, Input property, Lattice points in cones, Symmetry, Triangulation and volume, Visualization

    polytope> help "objects/Cone/properties/Combinatorics";
     These properties capture combinatorial information of the object. 
     Combinatorial properties only depend on combinatorial data of the object like, e.g., the face lattice.

    -------------------
    Subtopics of objects/Cone/properties/Combinatorics:
    COCIRCUIT_EQUATIONS, COMBINATORIAL_DIM, DUAL_GRAPH, ESSENTIALLY_GENERIC, F2_VECTOR, FACETS_THRU_RAYS, FACET_SIZES, FLAG_VECTOR, FOLDABLE_COCIRCUIT_EQUATIONS, F_VECTOR, GRAPH, HASSE_DIAGRAM, INTERIOR_RIDGE_SIMPLICES, MAX_BOUNDARY_SIMPLICES, MAX_INTERIOR_SIMPLICES, N_RAYS, N_RAY_FACET_INC, RAYS_IN_FACETS, RAY_SIZES, SELF_DUAL, SIMPLE, SIMPLICIAL, SIMPLICIAL_CONE

    polytope > help "objects/Cone/properties/Combinatorics/RAYS_IN_FACETS";
    property RAYS_IN_FACETS : IncidenceMatrix<NonSymmetric>
     Ray-facet incidence matrix, with rows corresponding to facets and columns
     to rays. Rays and facets are numbered from 0 to N_RAYS-1 rsp.
     N_FACETS-1, according to their order in RAYS rsp. FACETS.
"""
###############################################################################
#       Copyright (C) 2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################


from libcpp cimport bool
from libcpp.string cimport string

from .defs cimport *
from .perl_object cimport *
from .matrix cimport *
from .number cimport *
from .array cimport *
from .vector cimport *

#include "cysignals/signals.pxi"
#include "cysignals/memory.pxi"

cdef dict type_properties = {}
include "auto_properties.pxi"

# TODO: this should be a dynamical function
cpdef get_properties(bytes pm_type):
    global type_properties
    try:
        return type_properties[pm_type]
    except KeyError:
        print("  pypolymake debug WARNING: properties unknown for {}".format(pm_type))
        return {}

cdef extern from "wrap.h" namespace "polymake":
    void pm_get_PerlObject "GIVE" (pm_PerlObject, pm_PerlObject*, string)

    void pm_get1_int "GIVE" (int, pm_PerlObject*, string) except +
    void pm_get2_int "CALL_METHOD" (int, pm_PerlObject*, string) except +

    void pm_get1_float "GIVE" (float, pm_PerlObject*, string) except +
    void pm_get2_float "CALL_METHOD" (float, pm_PerlObject*, string) except +

    void pm_get1_Integer "GIVE" (pm_Integer, pm_PerlObject*, string) except +
    void pm_get1_Rational "GIVE" (pm_Rational, pm_PerlObject*, string) except +

    void pm_get1_ArrayInt "GIVE" (pm_ArrayInt, pm_PerlObject*, string) except +

    void pm_get1_VectorInteger "GIVE" (pm_VectorInteger, pm_PerlObject*, string) except +
    void pm_get1_VectorRational "GIVE" (pm_VectorRational, pm_PerlObject*, string) except +

    void pm_get1_MatrixInt "GIVE" (pm_MatrixInt, pm_PerlObject*, string) except +
    void pm_get1_MatrixInteger "GIVE" (pm_MatrixInteger, pm_PerlObject*, string) except +
    void pm_get1_MatrixRational "GIVE" (pm_MatrixRational, pm_PerlObject*, string) except +


    void pm_get2_Integer "CALL_METHOD" (pm_Integer, pm_PerlObject*, string) except +
    void pm_get2_Rational "CALL_METHOD" (pm_Rational, pm_PerlObject*, string) except +

    void pm_get2_ArrayInt "CALL_METHOD" (pm_ArrayInt, pm_PerlObject*, string) except +

    void pm_get2_VectorInteger "CALL_METHOD" (pm_VectorInteger, pm_PerlObject*, string) except +
    void pm_get2_VectorRational "CALL_METHOD" (pm_VectorRational, pm_PerlObject*, string) except +

    void pm_get2_MatrixInt "CALL_METHOD" (pm_MatrixInt, pm_PerlObject*, string) except +
    void pm_get2_MatrixInteger "CALL_METHOD" (pm_MatrixInteger, pm_PerlObject*, string) except +
    void pm_get2_MatrixRational "CALL_METHOD" (pm_MatrixRational, pm_PerlObject*, string) except +



def handler_generic(PerlObject perl_object, bytes prop):
    cdef pm_PerlObject pm_ans
    print("  pypolymake debug WARNING: generic handler")
    pm_get_PerlObject(pm_ans, perl_object.pm_obj, prop)
    if not pm_ans.valid():
        raise ValueError("invalid property {}".format(prop))

    return wrap_perl_object(pm_ans)

def handler_bool(PerlObject perl_object, bytes prop):
    return handler_int(perl_object, prop)

def handler_int(PerlObject perl_object, bytes prop):
    cdef int ans
    try:
        pm_get1_int(ans, perl_object.pm_obj, prop)
    except RuntimeError:
        pm_get2_int(ans, perl_object.pm_obj, prop)
    return ans

def handler_float(PerlObject perl_object, bytes prop):
    cdef float ans
    try:
        pm_get1_float(ans, perl_object.pm_obj, prop)
    except RuntimeError:
        pm_get2_float(ans, perl_object.pm_obj, prop)
    return ans

include "handlers.pxi"

cdef dict handlers = {
    b"Bool"          : handler_bool,
    b"Int"           : handler_int,
    b"Float"         : handler_float,
}
include "auto_mappings.pxi"
handlers.update(auto_handlers)


cpdef get_handler(bytes pm_type):
    global handlers
    try:
        return handlers[pm_type]
    except KeyError:
        print("  pypolymake debug WARNING: falling back to generic handler")
        return handler_generic
