###############################################################################
#       Copyright (C) 2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from .defs cimport (pm_PerlObject, new_PerlObject_from_PerlObject,
        pm_get_PerlObject, pm_MatrixRational, pm_VectorInteger, pm_Integer,
        pm_Rational, pm_get_Integer, pm_get_Rational, pm_get_MatrixRational,
        pm_get_VectorInteger, pm_get_PerlObject)

from .perl_object cimport PerlObject, wrap_perl_object
from .matrix cimport MatrixRational
from .number cimport Integer, Rational
from .vector cimport VectorInteger


# The names used below are the exact output of "PerlObject.type_name()". They
# also correspond to C++ types.
cdef pm_type_unknown = 'unknown'
cdef pm_type_bool = 'bool'
cdef pm_type_int = 'int'
cdef pm_type_integer = 'Integer'
cdef pm_type_rational = 'Rational'

cdef pm_type_array_int = 'Array<Int>'
cdef pm_type_array_string = 'Array<String>'
cdef pm_type_set_int = 'Set<Int>'

cdef pm_type_vector_integer = 'Vector<Integer>'
cdef pm_type_vector_rational = 'Vector<Rational>'
cdef pm_type_matrix_int = 'Matrix<Int, NonSymmetric>'
cdef pm_type_matrix_float = 'Matrix<Float, NonSymmetric>'
cdef pm_type_matrix_integer = 'Matrix<Integer, NonSymmetric>'
cdef pm_type_matrix_rational = 'Matrix<Rational, NonSymmetric>'
cdef pm_type_sparse_matrix_rational = 'SparseMatrix<Rational, NonSymmetric>'

cdef pm_type_polytope_rational = 'Polytope<Rational>'
cdef pm_type_quadratic_extension = 'Polytope<QuadraticExtension<Rational>>'
cdef pm_type_graph_undirected = 'Graph<Undirected>'

cdef dict type_properties = {}

# TODO: this should *not* be necessary. However, for basic types (like bool,
# int) the type discovery currently does not work.
type_properties[pm_type_polytope_rational] = {
    'AFFINE_HULL'                        : pm_type_matrix_rational,
    'ALTSHULER_DET'                      : pm_type_integer,
    'AMBIENT_DIM'                        : pm_type_unknown,
    'BALANCE'                            : pm_type_integer,
    'BALANCED'                           : pm_type_bool,
    'BOUNDARY_LATTICE_POINTS'            : pm_type_matrix_integer,
    'BOUNDED'                            : pm_type_bool,
    'BOUNDED_COMPLEX'                    : pm_type_unknown,
    'BOUNDED_DUAL_GRAPH'                 : pm_type_unknown,
    'BOUNDED_FACETS'                     : pm_type_unknown,
    'BOUNDED_GRAPH'                      : pm_type_unknown,
    'BOUNDED_HASSE_DIAGRAM'              : pm_type_unknown,
    'BOUNDED_VERTICES'                   : pm_type_unknown,
    'CANONICAL'                          : pm_type_unknown,
    'CD_INDEX'                           : pm_type_unknown,
    'CD_INDEX_COEFFICIENTS'              : pm_type_unknown,
    'CENTERED'                           : pm_type_bool,
    'CENTERED_ZONOTOPE'                  : pm_type_unknown,
    'CENTRALLY_SYMMETRIC'                : pm_type_bool,
    'CENTROID'                           : pm_type_unknown,
    'CHIROTOPE'                          : pm_type_unknown,
    'COCIRCUIT_EQUATIONS'                : pm_type_unknown,
    'COCUBICAL'                          : pm_type_bool,
    'COCUBICALITY'                       : pm_type_unknown,
    'COMBINATORIAL_DIM'                  : pm_type_integer,
    'COMPLEXITY'                         : pm_type_unknown,
    'COMPRESSED'                         : pm_type_unknown,
    'CONE_AMBIENT_DIM'                   : pm_type_unknown,
    'CONE_DIM'                           : pm_type_unknown,
    'CONNECTIVITY'                       : pm_type_unknown,
    'COORDINATE_LABELS'                  : pm_type_unknown,
    'CS_PERMUTATION'                     : pm_type_array_int,
    'CUBICAL'                            : pm_type_bool,
    'CUBICAL_H_VECTOR'                   : pm_type_vector_integer,
    'CUBICALITY'                         : pm_type_integer,
    'DEGREE_ONE_GENERATORS'              : pm_type_matrix_integer,
    'DIAMETER'                           : pm_type_unknown,
    'DIM'                                : pm_type_unknown,
    'DUAL_BOUNDED_H_VECTOR'              : pm_type_vector_integer,
    'DUAL_CONNECTIVITY'                  : pm_type_unknown,
    'DUAL_DIAMETER'                      : pm_type_unknown,
    'DUAL_EVEN'                          : pm_type_unknown,
    'DUAL_GRAPH'                         : pm_type_unknown,
    'DUAL_GRAPH_SIGNATURE'               : pm_type_unknown,
    'DUAL_H_VECTOR'                      : pm_type_vector_integer,
    'DUAL_TRIANGLE_FREE'                 : pm_type_unknown,
    'EDGE_ORIENTABLE'                    : pm_type_bool,
    'EDGE_ORIENTATION'                   : pm_type_matrix_int,
    'EHRHART_POLYNOMIAL_COEFF'           : pm_type_vector_rational,
    'EPSILON'                            : pm_type_unknown,
    'EQUATIONS'                          : pm_type_unknown,
    'ESSENTIALLY_GENERIC'                : pm_type_bool,
    'EVEN'                               : pm_type_unknown,
    'F2_VECTOR'                          : pm_type_matrix_integer,
    'FACE_SIMPLICITY'                    : pm_type_integer,
    'FACET_DEGREES'                      : pm_type_unknown,
    'FACET_LABELS'                       : pm_type_array_string,
    'FACET_POINT_LATTICE_DISTANCES'      : pm_type_unknown,
    'FACETS'                             : pm_type_sparse_matrix_rational,
    'FACET_SIZES'                        : pm_type_array_int,
    'FACETS_THRU_POINTS'                 : pm_type_unknown,
    'FACETS_THRU_VERTICES'               : pm_type_unknown,
    'FACET_VERTEX_LATTICE_DISTANCES'     : pm_type_matrix_integer,
    'FACET_WIDTH'                        : pm_type_integer,
    'FACET_WIDTHS'                       : pm_type_unknown,
    'FAR_FACE'                           : pm_type_set_int,
    'FAR_HYPERPLANE'                     : pm_type_vector_rational,
    'FATNESS'                            : pm_type_unknown,
    'FEASIBLE'                           : pm_type_bool,
    'FLAG_VECTOR'                        : pm_type_vector_integer,
    'FOLDABLE_COCIRCUIT_EQUATIONS'       : pm_type_unknown,
    'FOLDABLE_MAX_SIGNATURE_UPPER_BOUND' : pm_type_unknown,
    'FTV_CYCLIC_NORMAL'                  : pm_type_unknown,
    'FULL_DIM'                           : pm_type_unknown,
    'F_VECTOR'                           : pm_type_vector_integer,
    'GALE'                               : pm_type_unknown,
    'GALE_TRANSFORM'                     : pm_type_matrix_rational,
    'GALE_VERTICES'                      : pm_type_matrix_float,
    'GORENSTEIN'                         : pm_type_bool,
    'GORENSTEIN_CONE'                    : pm_type_bool,
    'GORENSTEIN_INDEX'                   : pm_type_integer,
    'GORENSTEIN_VECTOR'                  : pm_type_vector_integer,
    'GRAPH'                              : pm_type_unknown,
    'GRAPH_SIGNATURE'                    : pm_type_unknown,
    'GROEBNER_BASIS'                     : pm_type_unknown,
    'GROUP'                              : pm_type_unknown,
    'G_VECTOR'                           : pm_type_unknown,
    'HASSE_DIAGRAM'                      : pm_type_unknown,
    'HILBERT_BASIS'                      : pm_type_unknown,
    'HILBERT_BASIS_GENERATORS'           : pm_type_unknown,
    'HILBERT_SERIES'                     : pm_type_unknown,
    'HOMOGENEOUS'                        : pm_type_unknown,
    'H_STAR_VECTOR'                      : pm_type_unknown,
    'H_VECTOR'                           : pm_type_unknown,
    'INEQUALITIES'                       : pm_type_unknown,
    'INEQUALITIES_THRU_VERTICES'         : pm_type_unknown,
    'INEQUALITY_LABELS'                  : pm_type_unknown,
    'INNER_DESCRIPTION'                  : pm_type_unknown,
    'INPUT_LINEALITY'                    : pm_type_unknown,
    'INTERIOR_LATTICE_POINTS'            : pm_type_unknown,
    'INTERIOR_RIDGE_SIMPLICES'           : pm_type_unknown,
    'LATTICE'                            : pm_type_unknown,
    'LATTICE_BASIS'                      : pm_type_unknown,
    'LATTICE_CODEGREE'                   : pm_type_unknown,
    'LATTICE_DEGREE'                     : pm_type_unknown,
    'LATTICE_EMPTY'                      : pm_type_unknown,
    'LATTICE_POINTS'                     : pm_type_unknown,
    'LATTICE_POINTS_GENERATORS'          : pm_type_unknown,
    'LATTICE_VOLUME'                     : pm_type_unknown,
    'LATTICE_WIDTH'                      : pm_type_unknown,
    'LATTICE_WIDTH_DIRECTION'            : pm_type_unknown,
    'LINEALITY_DIM'                      : pm_type_unknown,
    'LINEALITY_SPACE'                    : pm_type_unknown,
    'LP'                                 : pm_type_unknown,
    'MAX_BOUNDARY_SIMPLICES'             : pm_type_unknown,
    'MAX_INTERIOR_SIMPLICES'             : pm_type_unknown,
    'MINIMAL_NON_FACES'                  : pm_type_unknown,
    'MINIMAL_VERTEX_ANGLE'               : pm_type_unknown,
    'MINKOWSKI_CONE'                     : pm_type_unknown,
    'MINKOWSKI_CONE_COEFF'               : pm_type_unknown,
    'MINKOWSKI_CONE_POINT'               : pm_type_unknown,
    'MOEBIUS_STRIP_EDGES'                : pm_type_unknown,
    'MOEBIUS_STRIP_QUADS'                : pm_type_unknown,
    'MONOID_GRADING'                     : pm_type_unknown,
    'N_01POINTS'                         : pm_type_unknown,
    'N_BOUNDARY_LATTICE_POINTS'          : pm_type_unknown,
    'N_BOUNDED_VERTICES'                 : pm_type_unknown,
    'N_EDGES'                            : pm_type_unknown,
    'NEIGHBOR_FACETS_CYCLIC_NORMAL'      : pm_type_unknown,
    'NEIGHBORLINESS'                     : pm_type_unknown,
    'NEIGHBORLY'                         : pm_type_unknown,
    'NEIGHBOR_VERTICES_CYCLIC_NORMAL'    : pm_type_unknown,
    'N_EQUATIONS'                        : pm_type_unknown,
    'N_FACETS'                           : pm_type_integer,
    'N_FLAGS'                            : pm_type_unknown,
    'N_HILBERT_BASIS'                    : pm_type_unknown,
    'N_INPUT_LINEALITY'                  : pm_type_unknown,
    'N_INTERIOR_LATTICE_POINTS'          : pm_type_unknown,
    'N_LATTICE_POINTS'                   : pm_type_unknown,
    'N_LATTICE_POINTS_IN_DILATION'       : pm_type_unknown,
    'NORMAL'                             : pm_type_unknown,
    'N_POINTS'                           : pm_type_unknown,
    'N_RIDGES'                           : pm_type_unknown,
    'N_VERTEX_FACET_INC'                 : pm_type_unknown,
    'N_VERTICES'                         : pm_type_integer,
    'ONE_VERTEX'                         : pm_type_unknown,
    'OUTER_DESCRIPTION'                  : pm_type_unknown,
    'POINTED'                            : pm_type_unknown,
    'POINT_LABELS'                       : pm_type_unknown,
    'POINTS'                             : pm_type_unknown,
    'POINTS_IN_FACETS'                   : pm_type_unknown,
    'POLAR_SMOOTH'                       : pm_type_unknown,
    'POLYTOPAL_SUBDIVISION'              : pm_type_unknown,
    'POLYTOPE_IN_STD_BASIS'              : pm_type_unknown,
    'POSITIVE'                           : pm_type_unknown,
    'Q_GORENSTEIN_CONE'                  : pm_type_unknown,
    'Q_GORENSTEIN_CONE_INDEX'            : pm_type_unknown,
    'QUOTIENT_SPACE'                     : pm_type_unknown,
    'REFLEXIVE'                          : pm_type_unknown,
    'RELATIVE_VOLUME'                    : pm_type_unknown,
    'REL_INT_POINT'                      : pm_type_unknown,
    'SCHLEGEL'                           : pm_type_unknown,
    'SCHLEGEL_DIAGRAM'                   : pm_type_unknown,
    'SELF_DUAL'                          : pm_type_unknown,
    'SIMPLE'                             : pm_type_bool,
    'SIMPLE_POLYHEDRON'                  : pm_type_unknown,
    'SIMPLEXITY_LOWER_BOUND'             : pm_type_unknown,
    'SIMPLICIAL'                         : pm_type_bool,
    'SIMPLICIAL_CONE'                    : pm_type_unknown,
    'SIMPLICIALITY'                      : pm_type_unknown,
    'SIMPLICITY'                         : pm_type_unknown,
    'SMOOTH'                             : pm_type_unknown,
    'SMOOTH_CONE'                        : pm_type_unknown,
    'SPECIAL_FACETS'                     : pm_type_unknown,
    'SPLIT_COMPATIBILITY_GRAPH'          : pm_type_unknown,
    'SPLITS'                             : pm_type_unknown,
    'SQUARED_RELATIVE_VOLUMES'           : pm_type_unknown,
    'STEINER_POINT'                      : pm_type_unknown,
    'STEINER_POINTS'                     : pm_type_unknown,
    'SUBRIDGE_SIZES'                     : pm_type_unknown,
    'TERMINAL'                           : pm_type_unknown,
    'TILING_LATTICE'                     : pm_type_unknown,
    'TOWARDS_FAR_FACE'                   : pm_type_unknown,
    'TRIANGLE_FREE'                      : pm_type_unknown,
    'TRIANGULATION'                      : pm_type_unknown,
    'TRIANGULATION_INT'                  : pm_type_unknown,
    'TRIANGULATION_INT_SIGNS'            : pm_type_unknown,
    'TRIANGULATION_SIGNS'                : pm_type_unknown,
    'TWO_FACE_SIZES'                     : pm_type_unknown,
    'UNBOUNDED_FACETS'                   : pm_type_unknown,
    'VALID_POINT'                        : pm_type_unknown,
    'VERTEX_BARYCENTER'                  : pm_type_unknown,
    'VERTEX_DEGREES'                     : pm_type_unknown,
    'VERTEX_LABELS'                      : pm_type_unknown,
    'VERTEX_NORMALS'                     : pm_type_unknown,
    'VERTEX_SIZES'                       : pm_type_unknown,
    'VERTICES'                           : pm_type_matrix_rational,
    'VERTICES_IN_FACETS'                 : pm_type_unknown,
    'VERTICES_IN_INEQUALITIES'           : pm_type_unknown,
    'VERY_AMPLE'                         : pm_type_unknown,
    'VIF_CYCLIC_NORMAL'                  : pm_type_unknown,
    'VISUAL'                             : pm_type_unknown,
    'VISUAL_BOUNDED_GRAPH'               : pm_type_unknown,
    'VISUAL_DUAL'                        : pm_type_unknown,
    'VISUAL_DUAL_FACE_LATTICE'           : pm_type_unknown,
    'VISUAL_DUAL_GRAPH'                  : pm_type_unknown,
    'VISUAL_FACE_LATTICE'                : pm_type_unknown,
    'VISUAL_GRAPH'                       : pm_type_unknown,
    'VISUAL_TRIANGULATION_BOUNDARY'      : pm_type_unknown,
    'VOLUME'                             : pm_type_unknown,
    'WEAKLY_CENTERED'                    : pm_type_bool,
    'ZONOTOPE_INPUT_POINTS'              : pm_type_unknown,
}

type_properties[pm_type_graph_undirected]    = {
    'ADJACENCY'                       : pm_type_unknown,
    'AVERAGE_DEGREE'                  : pm_type_rational,
    'BIPARTITE'                       : pm_type_bool,
    'CHARACTERISTIC_POLYNOMIAL'       : pm_type_unknown,
    'CONNECTED'                       : pm_type_bool,
    'CONNECTED_COMPONENTS'            : pm_type_unknown,
    'CONNECTIVITY'                    : pm_type_integer,
    'DEGREE_SEQUENCE'                 : pm_type_unknown,
    'DIAMETER'                        : pm_type_integer,
    'EDGE_DIRECTIONS'                 : pm_type_unknown,
    'EDGES'                           : pm_type_unknown,
    'LATTICE_ACCUMULATED_EDGE_LENGTHS': pm_type_unknown,
    'LATTICE_EDGE_LENGTHS'            : pm_type_unknown,
    'MAX_CLIQUES'                     : pm_type_unknown,
    'N_CONNECTED_COMPONENTS'          : pm_type_integer,
    'N_EDGES'                         : pm_type_integer,
    'N_NODES'                         : pm_type_integer,
    'NODE_DEGREES'                    : pm_type_unknown,
    'NODE_IN_DEGREES'                 : pm_type_unknown,
    'NODE_LABELS'                     : pm_type_unknown,
    'NODE_OUT_DEGREES'                : pm_type_unknown,
    'SIGNATURE'                       : pm_type_integer,
    'SIGNED_INCIDENCE_MATRIX'         : pm_type_unknown,
    'SQUARED_EDGE_LENGTHS'            : pm_type_unknown,
    'TRIANGLE_FREE'                   : pm_type_bool,
    'VISUAL'                          : pm_type_unknown,
}

def handler_generic(perl_object, prop):
    cdef pm_PerlObject * po = (<PerlObject?> perl_object).pm_obj
    cdef pm_PerlObject pm_ans
    pm_get_PerlObject(po.give(prop), pm_ans)
    if not pm_ans.valid():
        raise ValueError("invalid property")

    return wrap_perl_object(pm_ans)

def handler_bool(perl_object, prop):
    cdef pm_PerlObject * po = (<PerlObject?> perl_object).pm_obj
    cdef pm_Integer pm_ans
    pm_get_Integer(po.give(prop), pm_ans)
    return bool(pm_ans.compare(0))

def handler_integer(perl_object, prop):
    cdef pm_PerlObject * po = (<PerlObject?> perl_object).pm_obj
    cdef Integer ans = Integer.__new__(Integer)
    pm_get_Integer(po.give(prop), ans.pm_obj)
    return ans

def handler_rational(perl_object, prop):
    cdef pm_PerlObject * po = (<PerlObject?> perl_object).pm_obj
    cdef Rational ans = Rational.__new__(Rational)
    pm_get_Rational(po.give(prop), ans.pm_obj)
    return ans

def handler_vector_integer(perl_object, prop):
    cdef pm_PerlObject * po = (<PerlObject?> perl_object).pm_obj
    cdef VectorInteger ans = VectorInteger.__new__(VectorInteger)
    pm_get_VectorInteger(po.give(prop), ans.pm_obj)
    return ans

def handler_matrix_rational(perl_object, prop):
    cdef pm_PerlObject * po = (<PerlObject?> perl_object).pm_obj
    cdef MatrixRational ans = MatrixRational.__new__(MatrixRational)
    pm_get_MatrixRational(po.give(prop), ans.pm_obj)
    return ans

cdef dict handlers = {
    pm_type_unknown          : handler_generic,

    # numbers
    pm_type_bool     : handler_bool,
    pm_type_int      : handler_integer,
    pm_type_integer  : handler_integer,
    pm_type_rational : handler_rational,

    # array, set and vectors
    pm_type_array_int       : handler_generic,
    pm_type_array_string    : handler_generic,
    pm_type_set_int         : handler_generic,
    pm_type_vector_integer  : handler_vector_integer,
    pm_type_vector_rational : handler_generic,

    # matrices
    pm_type_matrix_int             : handler_generic,
    pm_type_matrix_integer         : handler_generic,
    pm_type_matrix_rational        : handler_matrix_rational,
    pm_type_sparse_matrix_rational : handler_generic,

    # others
    pm_type_polytope_rational: handler_generic,
    pm_type_graph_undirected : handler_generic,
}
