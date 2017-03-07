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

from .defs cimport *
from .perl_object cimport *
from .matrix cimport *
from .number cimport *
from .array cimport *
from .vector cimport *


include "cysignals/signals.pxi"
include "cysignals/memory.pxi"

# The names used below are the exact output of "PerlObject.type_name()". They
# also correspond to C++ types.
# Though, it does not always work (e.g. DUAL_GRAPH gets
# 'Graph<Undirected> as Polytope<Rational>::DUAL_GRAPH')
cdef pm_type_unknown = b'unknown'
cdef pm_type_bool = b'bool'
cdef pm_type_int = b'int'
cdef pm_type_float = b'float'
cdef pm_type_integer = b'Integer'
cdef pm_type_rational = b'Rational'

cdef pm_type_array_int = b'Array<Int>'
cdef pm_type_array_string = b'Array<String>'
cdef pm_type_array_array_int = b'Array<Array<Int>>'
cdef pm_type_set_int = b'Set<Int>'
cdef pm_type_array_set_int = b'Array<Set<Int>>'
cdef pm_type_map_int_int = b'Map<Int, Int>'

cdef pm_type_vector_integer = b'Vector<Integer>'
cdef pm_type_vector_rational = b'Vector<Rational>'
cdef pm_type_matrix_int = b'Matrix<Int, NonSymmetric>'
cdef pm_type_matrix_float = b'Matrix<Float, NonSymmetric>'
cdef pm_type_matrix_integer = b'Matrix<Integer, NonSymmetric>'
cdef pm_type_matrix_rational = b'Matrix<Rational, NonSymmetric>'
cdef pm_type_sparse_matrix_rational = b'SparseMatrix<Rational, NonSymmetric>'
cdef pm_type_incidence_matrix = b'IncidenceMatrix<NonSymmetric>'

cdef pm_type_polytope_rational = b'Polytope<Rational>'
cdef pm_type_quadratic_extension = b'Polytope<QuadraticExtension<Rational>>'
cdef pm_type_graph_undirected = b'Graph<Undirected>'

cdef pm_type_geometric_simplicial_complex_rational = b'GeometricSimplicialComplex<Rational>'

cdef dict type_properties = {}

# TODO: this should *not* be necessary. However, for basic types (like bool,
# int) the type discovery currently does not work.
type_properties[pm_type_polytope_rational] = {
    b'AFFINE_HULL'                        : pm_type_matrix_rational,
    b'ALTSHULER_DET'                      : pm_type_integer,
    b'AMBIENT_DIM'                        : pm_type_int,
    b'BALANCE'                            : pm_type_integer,
    b'BALANCED'                           : pm_type_bool,
    b'BOUNDARY_LATTICE_POINTS'            : pm_type_matrix_integer,
    b'BOUNDED'                            : pm_type_bool,
    b'BOUNDED_COMPLEX'                    : pm_type_unknown, # ValueError: unknown property
    b'BOUNDED_DUAL_GRAPH'                 : pm_type_unknown, # ValueError: unknown property
    b'BOUNDED_FACETS'                     : pm_type_unknown, # ValueError: unknown property
    b'BOUNDED_GRAPH'                      : pm_type_unknown, # ValueError: unknown property
    b'BOUNDED_HASSE_DIAGRAM'              : pm_type_unknown, # ValueError: unknown property
    b'BOUNDED_VERTICES'                   : pm_type_unknown, # ValueError: unknown property
    b'CANONICAL'                          : pm_type_unknown, # ValueError: invalid property
    b'CD_INDEX'                           : pm_type_unknown, # ValueError: unknown property
    b'CD_INDEX_COEFFICIENTS'              : pm_type_vector_integer,
    b'CENTERED'                           : pm_type_bool,
    b'CENTERED_ZONOTOPE'                  : pm_type_unknown, # ValueError: unexpected undefined value of an input property
    b'CENTRALLY_SYMMETRIC'                : pm_type_bool,
    b'CENTROID'                           : pm_type_vector_rational,
    b'CHIROTOPE'                          : pm_type_unknown, # ValueError: unexpected undefined value of an input property
    b'COCIRCUIT_EQUATIONS'                : pm_type_sparse_matrix_rational,
    b'COCUBICAL'                          : pm_type_bool,
    b'COCUBICALITY'                       : pm_type_unknown, # ValueError: invalid property
    b'COMBINATORIAL_DIM'                  : pm_type_integer,
    b'COMPLEXITY'                         : pm_type_float,
    b'COMPRESSED'                         : pm_type_unknown, # ValueError: invalid property
    b'CONE_AMBIENT_DIM'                   : pm_type_unknown, # ValueError: invalid property
    b'CONE_DIM'                           : pm_type_unknown, # ValueError: invalid property
    b'CONNECTIVITY'                       : pm_type_unknown, # ValueError: unknown property
    b'COORDINATE_LABELS'                  : pm_type_unknown, # ValueError: unexpected undefined value of an input property
    b'CS_PERMUTATION'                     : pm_type_array_int,
    b'CUBICAL'                            : pm_type_bool,
    b'CUBICAL_H_VECTOR'                   : pm_type_vector_integer,
    b'CUBICALITY'                         : pm_type_integer,
    b'DEGREE_ONE_GENERATORS'              : pm_type_matrix_integer,
    b'DIAMETER'                           : pm_type_int,
    b'DIM'                                : pm_type_int,
    b'DUAL_BOUNDED_H_VECTOR'              : pm_type_vector_integer,
    b'DUAL_CONNECTIVITY'                  : pm_type_unknown, # ValueError: unknown property
    b'DUAL_DIAMETER'                      : pm_type_unknown, # ValueError: unknown property
    b'DUAL_EVEN'                          : pm_type_unknown, # ValueError: unknown property
    b'DUAL_GRAPH'                         : pm_type_graph_undirected,
    b'DUAL_GRAPH_SIGNATURE'               : pm_type_unknown, # ValueError: unknown property 
    b'DUAL_H_VECTOR'                      : pm_type_vector_integer, # ValueError: unknown property
    b'DUAL_TRIANGLE_FREE'                 : pm_type_unknown, # ValueError: unknown property
    b'EDGE_ORIENTABLE'                    : pm_type_bool,
    b'EDGE_ORIENTATION'                   : pm_type_matrix_int,
    b'EHRHART_POLYNOMIAL_COEFF'           : pm_type_vector_rational,
    b'EPSILON'                            : pm_type_unknown, # ValueError: unknown property
    b'EQUATIONS'                          : pm_type_unknown,
    b'ESSENTIALLY_GENERIC'                : pm_type_bool,
    b'EVEN'                               : pm_type_unknown,
    b'F2_VECTOR'                          : pm_type_matrix_integer,
    b'FACE_SIMPLICITY'                    : pm_type_integer,
    b'FACET_DEGREES'                      : pm_type_unknown, # ValueError: unknown property
    b'FACET_LABELS'                       : pm_type_array_string,
    b'FACET_POINT_LATTICE_DISTANCES'      : pm_type_unknown,
    b'FACETS'                             : pm_type_sparse_matrix_rational,
    b'FACET_SIZES'                        : pm_type_array_int,
    b'FACETS_THRU_POINTS'                 : pm_type_unknown,
    b'FACETS_THRU_VERTICES'               : pm_type_unknown,
    b'FACET_VERTEX_LATTICE_DISTANCES'     : pm_type_matrix_integer,
    b'FACET_WIDTH'                        : pm_type_integer,
    b'FACET_WIDTHS'                       : pm_type_unknown,
    b'FAR_FACE'                           : pm_type_set_int,
    b'FAR_HYPERPLANE'                     : pm_type_vector_rational,
    b'FATNESS'                            : pm_type_unknown,
    b'FEASIBLE'                           : pm_type_bool,
    b'FLAG_VECTOR'                        : pm_type_vector_integer,
    b'FOLDABLE_COCIRCUIT_EQUATIONS'       : pm_type_unknown,
    b'FOLDABLE_MAX_SIGNATURE_UPPER_BOUND' : pm_type_unknown,
    b'FTV_CYCLIC_NORMAL'                  : pm_type_unknown,
    b'FULL_DIM'                           : pm_type_unknown,
    b'F_VECTOR'                           : pm_type_vector_integer,
    b'GALE'                               : pm_type_unknown,
    b'GALE_TRANSFORM'                     : pm_type_matrix_rational,
    b'GALE_VERTICES'                      : pm_type_matrix_float,
    b'GORENSTEIN'                         : pm_type_bool,
    b'GORENSTEIN_CONE'                    : pm_type_bool,
    b'GORENSTEIN_INDEX'                   : pm_type_integer,
    b'GORENSTEIN_VECTOR'                  : pm_type_vector_integer,
    b'GRAPH'                              : pm_type_unknown,
    b'GRAPH_SIGNATURE'                    : pm_type_unknown,
    b'GROEBNER_BASIS'                     : pm_type_unknown,
    b'GROUP'                              : pm_type_unknown,
    b'G_VECTOR'                           : pm_type_unknown,
    b'HASSE_DIAGRAM'                      : pm_type_unknown,
    b'HILBERT_BASIS'                      : pm_type_unknown,
    b'HILBERT_BASIS_GENERATORS'           : pm_type_unknown,
    b'HILBERT_SERIES'                     : pm_type_unknown,
    b'HOMOGENEOUS'                        : pm_type_unknown,
    b'H_STAR_VECTOR'                      : pm_type_unknown,
    b'H_VECTOR'                           : pm_type_unknown,
    b'INEQUALITIES'                       : pm_type_unknown,
    b'INEQUALITIES_THRU_VERTICES'         : pm_type_unknown,
    b'INEQUALITY_LABELS'                  : pm_type_unknown,
    b'INNER_DESCRIPTION'                  : pm_type_unknown,
    b'INPUT_LINEALITY'                    : pm_type_unknown,
    b'INTERIOR_LATTICE_POINTS'            : pm_type_unknown,
    b'INTERIOR_RIDGE_SIMPLICES'           : pm_type_unknown,
    b'LATTICE'                            : pm_type_unknown,
    b'LATTICE_BASIS'                      : pm_type_unknown,
    b'LATTICE_CODEGREE'                   : pm_type_unknown,
    b'LATTICE_DEGREE'                     : pm_type_unknown,
    b'LATTICE_EMPTY'                      : pm_type_unknown,
    b'LATTICE_POINTS'                     : pm_type_unknown,
    b'LATTICE_POINTS_GENERATORS'          : pm_type_unknown,
    b'LATTICE_VOLUME'                     : pm_type_unknown,
    b'LATTICE_WIDTH'                      : pm_type_unknown,
    b'LATTICE_WIDTH_DIRECTION'            : pm_type_unknown,
    b'LINEALITY_DIM'                      : pm_type_unknown,
    b'LINEALITY_SPACE'                    : pm_type_unknown,
    b'LP'                                 : pm_type_unknown,
    b'MAX_BOUNDARY_SIMPLICES'             : pm_type_unknown,
    b'MAX_INTERIOR_SIMPLICES'             : pm_type_unknown,
    b'MINIMAL_NON_FACES'                  : pm_type_unknown,
    b'MINIMAL_VERTEX_ANGLE'               : pm_type_unknown,
    b'MINKOWSKI_CONE'                     : pm_type_unknown,
    b'MINKOWSKI_CONE_COEFF'               : pm_type_unknown,
    b'MINKOWSKI_CONE_POINT'               : pm_type_unknown,
    b'MOEBIUS_STRIP_EDGES'                : pm_type_unknown,
    b'MOEBIUS_STRIP_QUADS'                : pm_type_unknown,
    b'MONOID_GRADING'                     : pm_type_unknown,
    b'N_01POINTS'                         : pm_type_unknown,
    b'N_BOUNDARY_LATTICE_POINTS'          : pm_type_unknown,
    b'N_BOUNDED_VERTICES'                 : pm_type_unknown,
    b'N_EDGES'                            : pm_type_int,
    b'NEIGHBOR_FACETS_CYCLIC_NORMAL'      : pm_type_unknown,
    b'NEIGHBORLINESS'                     : pm_type_unknown,
    b'NEIGHBORLY'                         : pm_type_unknown,
    b'NEIGHBOR_VERTICES_CYCLIC_NORMAL'    : pm_type_unknown,
    b'N_EQUATIONS'                        : pm_type_unknown,
    b'N_FACETS'                           : pm_type_integer,
    b'N_FLAGS'                            : pm_type_unknown,
    b'N_HILBERT_BASIS'                    : pm_type_unknown,
    b'N_INPUT_LINEALITY'                  : pm_type_unknown,
    b'N_INTERIOR_LATTICE_POINTS'          : pm_type_unknown,
    b'N_LATTICE_POINTS'                   : pm_type_unknown,
    b'N_LATTICE_POINTS_IN_DILATION'       : pm_type_unknown,
    b'NORMAL'                             : pm_type_unknown,
    b'N_POINTS'                           : pm_type_unknown,
    b'N_RIDGES'                           : pm_type_unknown,
    b'N_VERTEX_FACET_INC'                 : pm_type_unknown,
    b'N_VERTICES'                         : pm_type_integer,
    b'ONE_VERTEX'                         : pm_type_unknown,
    b'OUTER_DESCRIPTION'                  : pm_type_unknown,
    b'POINTED'                            : pm_type_unknown,
    b'POINT_LABELS'                       : pm_type_unknown,
    b'POINTS'                             : pm_type_unknown,
    b'POINTS_IN_FACETS'                   : pm_type_unknown,
    b'POLAR_SMOOTH'                       : pm_type_unknown,
    b'POLYTOPAL_SUBDIVISION'              : pm_type_unknown,
    b'POLYTOPE_IN_STD_BASIS'              : pm_type_unknown,
    b'POSITIVE'                           : pm_type_unknown,
    b'Q_GORENSTEIN_CONE'                  : pm_type_unknown,
    b'Q_GORENSTEIN_CONE_INDEX'            : pm_type_unknown,
    b'QUOTIENT_SPACE'                     : pm_type_unknown,
    b'REFLEXIVE'                          : pm_type_unknown,
    b'RELATIVE_VOLUME'                    : pm_type_unknown,
    b'REL_INT_POINT'                      : pm_type_unknown,
    b'SCHLEGEL'                           : pm_type_unknown,
    b'SCHLEGEL_DIAGRAM'                   : pm_type_unknown,
    b'SELF_DUAL'                          : pm_type_unknown,
    b'SIMPLE'                             : pm_type_bool,
    b'SIMPLE_POLYHEDRON'                  : pm_type_unknown,
    b'SIMPLEXITY_LOWER_BOUND'             : pm_type_unknown,
    b'SIMPLICIAL'                         : pm_type_bool,
    b'SIMPLICIAL_CONE'                    : pm_type_unknown,
    b'SIMPLICIALITY'                      : pm_type_unknown,
    b'SIMPLICITY'                         : pm_type_unknown,
    b'SMOOTH'                             : pm_type_unknown,
    b'SMOOTH_CONE'                        : pm_type_unknown,
    b'SPECIAL_FACETS'                     : pm_type_unknown,
    b'SPLIT_COMPATIBILITY_GRAPH'          : pm_type_unknown,
    b'SPLITS'                             : pm_type_unknown,
    b'SQUARED_RELATIVE_VOLUMES'           : pm_type_unknown,
    b'STEINER_POINT'                      : pm_type_unknown,
    b'STEINER_POINTS'                     : pm_type_unknown,
    b'SUBRIDGE_SIZES'                     : pm_type_unknown,
    b'TERMINAL'                           : pm_type_unknown,
    b'TILING_LATTICE'                     : pm_type_unknown,
    b'TOWARDS_FAR_FACE'                   : pm_type_unknown, # only defined for unbounded polyhedra
    b'TRIANGLE_FREE'                      : pm_type_unknown, # ValueError: unknown property
    b'TRIANGULATION'                      : pm_type_geometric_simplicial_complex_rational, 
    b'TRIANGULATION_INT'                  : pm_type_unknown, # ValueError: unexpected undefined value
    b'TRIANGULATION_INT_SIGNS'            : pm_type_unknown, # ValueError: unknown property 
    b'TRIANGULATION_SIGNS'                : pm_type_unknown, # ValueError: unknown property
    b'TWO_FACE_SIZES'                     : pm_type_map_int_int,
    b'UNBOUNDED_FACETS'                   : pm_type_set_int,
    b'VALID_POINT'                        : pm_type_vector_rational,
    b'VERTEX_BARYCENTER'                  : pm_type_vector_rational,
    b'VERTEX_DEGREES'                     : pm_type_unknown, # ValueError: unknown property
    b'VERTEX_LABELS'                      : pm_type_array_string,
    b'VERTEX_NORMALS'                     : pm_type_matrix_rational,
    b'VERTEX_SIZES'                       : pm_type_array_int,
    b'VERTICES'                           : pm_type_matrix_rational,
    b'VERTICES_IN_FACETS'                 : pm_type_incidence_matrix,
    b'VERTICES_IN_INEQUALITIES'           : pm_type_unknown, # ValueError: unexpected undefined value
    b'VERY_AMPLE'                         : pm_type_bool,
    b'VIF_CYCLIC_NORMAL'                  : pm_type_array_array_int,
#    b'VISUAL'                             : pm_type_unknown,
#    b'VISUAL_BOUNDED_GRAPH'               : pm_type_unknown,
#    b'VISUAL_DUAL'                        : pm_type_unknown,
#    b'VISUAL_DUAL_FACE_LATTICE'           : pm_type_unknown,
#    b'VISUAL_DUAL_GRAPH'                  : pm_type_unknown,
#    b'VISUAL_FACE_LATTICE'                : pm_type_unknown,
#    b'VISUAL_GRAPH'                       : pm_type_unknown,
#    b'VISUAL_TRIANGULATION_BOUNDARY'      : pm_type_unknown,  # ValueError: unknown property
    b'VOLUME'                             : pm_type_rational,
    b'WEAKLY_CENTERED'                    : pm_type_bool,
    b'ZONOTOPE_INPUT_POINTS'              : pm_type_unknown,
}

type_properties[pm_type_graph_undirected]    = {
    b'ADJACENCY'                       : pm_type_unknown,
    b'AVERAGE_DEGREE'                  : pm_type_rational,
    b'BIPARTITE'                       : pm_type_bool,
    b'CHARACTERISTIC_POLYNOMIAL'       : pm_type_unknown,
    b'CONNECTED'                       : pm_type_bool,
    b'CONNECTED_COMPONENTS'            : pm_type_unknown,
    b'CONNECTIVITY'                    : pm_type_integer,
    b'DEGREE_SEQUENCE'                 : pm_type_unknown,
    b'DIAMETER'                        : pm_type_integer,
    b'EDGE_DIRECTIONS'                 : pm_type_unknown,
    b'EDGES'                           : pm_type_array_set_int,
    b'LATTICE_ACCUMULATED_EDGE_LENGTHS': pm_type_unknown,
    b'LATTICE_EDGE_LENGTHS'            : pm_type_unknown,
    b'MAX_CLIQUES'                     : pm_type_unknown,
    b'N_CONNECTED_COMPONENTS'          : pm_type_integer,
    b'N_EDGES'                         : pm_type_int,
    b'N_NODES'                         : pm_type_integer,
    b'NODE_DEGREES'                    : pm_type_unknown,
    b'NODE_IN_DEGREES'                 : pm_type_unknown,
    b'NODE_LABELS'                     : pm_type_unknown,
    b'NODE_OUT_DEGREES'                : pm_type_unknown,
    b'SIGNATURE'                       : pm_type_integer,
    b'SIGNED_INCIDENCE_MATRIX'         : pm_type_unknown,
    b'SQUARED_EDGE_LENGTHS'            : pm_type_unknown,
    b'TRIANGLE_FREE'                   : pm_type_bool,
    b'VISUAL'                          : pm_type_unknown,
}

type_properties[pm_type_geometric_simplicial_complex_rational] = {
    b'BALL'                            : pm_type_unknown,
    b'BIPARTITE'                       : pm_type_unknown,
    b'BOUNDARY'                        : pm_type_unknown,
    b'CLOSED_PSEUDO_MANIFOLD'          : pm_type_unknown,
    b'COCYCLES'                        : pm_type_unknown,
    b'COHOMOLOGY'                      : pm_type_unknown,
    b'COLORING'                        : pm_type_unknown,
    b'CONNECTED'                       : pm_type_unknown,
    b'CONNECTED_COMPONENTS'            : pm_type_unknown,
    b'CONNECTIVITY'                    : pm_type_unknown,
    b'COORDINATES'                     : pm_type_unknown,
    b'CYCLES'                          : pm_type_unknown,
    b'DIM'                             : pm_type_unknown,
    b'DUAL_BIPARTITE'                  : pm_type_unknown,
    b'DUAL_CONNECTED'                  : pm_type_unknown,
    b'DUAL_CONNECTED_COMPONENTS'       : pm_type_unknown,
    b'DUAL_CONNECTIVITY'               : pm_type_unknown,
    b'DUAL_GRAPH'                      : pm_type_unknown,
    b'DUAL_GRAPH_SIGNATURE'            : pm_type_unknown,
    b'DUAL_MAX_CLIQUES'                : pm_type_unknown,
    b'EULER_CHARACTERISTIC'            : pm_type_unknown,
    b'F2_VECTOR'                       : pm_type_unknown,
    b'FACETS'                          : pm_type_unknown,
    b'FOLDABLE'                        : pm_type_unknown,
    b'FUNDAMENTAL_GROUP'               : pm_type_unknown,
    b'FUNDAMENTAL_GROUP_G'             : pm_type_unknown,
    b'F_VECTOR'                        : pm_type_unknown,
    b'G_DIM'                           : pm_type_unknown,
    b'GENUS'                           : pm_type_unknown,
    b'GKZ_VECTOR'                      : pm_type_unknown,
    b'GRAPH'                           : pm_type_unknown,
    b'GRAPH_SIGNATURE'                 : pm_type_unknown
}


def handler_generic(PerlObject perl_object, bytes prop):
    cdef pm_PerlObject pm_ans
    print("  pypolymake debug WARNING: generic handler")
    sig_on()
    pm_ans = perl_object.pm_obj.give_PerlObject(prop)
    sig_off()
    if not pm_ans.valid():
        raise ValueError("invalid property {}".format(prop))

    return wrap_perl_object(pm_ans)

def handler_bool(PerlObject perl_object, bytes prop):
    return handler_int(perl_object, prop)

def handler_int(PerlObject perl_object, bytes prop):
    cdef int ans
    try:
        sig_on()
        ans = perl_object.pm_obj.give_int(prop)
        sig_off()
    except ValueError:
        sig_on()
        ans = perl_object.pm_obj.call_method_int(prop)
        sig_off()
    return ans

def handler_float(PerlObject perl_object, bytes prop):
    cdef float ans
    try:
        sig_on()
        ans = perl_object.pm_obj.give_float(prop)
        sig_off()
    except ValueError:
        sig_on()
        ans = perl_object.pm_obj.call_method_float(prop)
        sig_off()
    return ans

include "handlers.pxi"

cdef dict handlers = {
    pm_type_unknown  : handler_generic,

    # numbers
    pm_type_bool     : handler_bool,
    pm_type_int      : handler_int,
    pm_type_float    : handler_float,
}
include "auto_mappings.pxi"
handlers.update(auto_handlers)
