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

from .perl_object cimport PerlObject
from .matrix cimport MatrixRational
from .number cimport Integer, Rational
from .vector cimport VectorInteger

# TODO: the underlying type of the Perl object could in principle be obtained
# from

cdef property_unknown = 'unknown'
cdef property_bool = 'bool'
cdef property_int = 'int'
cdef property_integer = 'integer'
cdef property_rational = 'Rational'

cdef property_array_int = 'Array<Int>'
cdef property_array_string = 'Array<String>'
cdef property_set_int = 'Set<Int>'

cdef property_vector_integer = 'Vector<Integer>'
cdef property_vector_rational = 'Vector<Rational>'
cdef property_matrix_int = 'Matrix<Int, NonSymmetric>'
cdef property_matrix_float = 'Matrix<Float, NonSymmetric>'
cdef property_matrix_integer = 'Matrix<Integer, NonSymmetric>'
cdef property_matrix_rational = 'Matrix<Rational, NonSymmetric>'
cdef property_sparse_matrix_rational = 'SparseMatrix<Rational, NonSymmetric>'

cdef property_polytope_rational = 'Polytope<Rational>'
cdef property_graph_undirected = 'Graph<Undirected>'

cdef dict polytope_rational_properties = {
    'AFFINE_HULL'                        : property_matrix_rational,
    'ALTSHULER_DET'                      : property_integer,
    'AMBIENT_DIM'                        : property_unknown,
    'BALANCE'                            : property_integer,
    'BALANCED'                           : property_bool,
    'BOUNDARY_LATTICE_POINTS'            : property_matrix_integer,
    'BOUNDED'                            : property_bool,
    'BOUNDED_COMPLEX'                    : property_unknown,
    'BOUNDED_DUAL_GRAPH'                 : property_unknown,
    'BOUNDED_FACETS'                     : property_unknown,
    'BOUNDED_GRAPH'                      : property_unknown,
    'BOUNDED_HASSE_DIAGRAM'              : property_unknown,
    'BOUNDED_VERTICES'                   : property_unknown,
    'CANONICAL'                          : property_unknown,
    'CD_INDEX'                           : property_unknown,
    'CD_INDEX_COEFFICIENTS'              : property_unknown,
    'CENTERED'                           : property_bool,
    'CENTERED_ZONOTOPE'                  : property_unknown,
    'CENTRALLY_SYMMETRIC'                : property_bool,
    'CENTROID'                           : property_unknown,
    'CHIROTOPE'                          : property_unknown,
    'COCIRCUIT_EQUATIONS'                : property_unknown,
    'COCUBICAL'                          : property_bool,
    'COCUBICALITY'                       : property_unknown,
    'COMBINATORIAL_DIM'                  : property_integer,
    'COMPLEXITY'                         : property_unknown,
    'COMPRESSED'                         : property_unknown,
    'CONE_AMBIENT_DIM'                   : property_unknown,
    'CONE_DIM'                           : property_unknown,
    'CONNECTIVITY'                       : property_unknown,
    'CENTERED'                           : property_bool,
    'COORDINATE_LABELS'                  : property_unknown,
    'CS_PERMUTATION'                     : property_array_int,
    'CUBICAL'                            : property_bool,
    'CUBICAL_H_VECTOR'                   : property_vector_integer,
    'CUBICALITY'                         : property_integer,
    'DEGREE_ONE_GENERATORS'              : property_matrix_integer,
    'DIAMETER'                           : property_unknown,
    'DIM'                                : property_unknown,
    'DUAL_BOUNDED_H_VECTOR'              : property_vector_integer,
    'DUAL_CONNECTIVITY'                  : property_unknown,
    'DUAL_DIAMETER'                      : property_unknown,
    'DUAL_EVEN'                          : property_unknown,
    'DUAL_GRAPH'                         : property_unknown,
    'DUAL_GRAPH_SIGNATURE'               : property_unknown,
    'DUAL_H_VECTOR'                      : property_vector_integer,
    'DUAL_TRIANGLE_FREE'                 : property_unknown,
    'EDGE_ORIENTABLE'                    : property_bool,
    'EDGE_ORIENTATION'                   : property_matrix_int,
    'EHRHART_POLYNOMIAL_COEFF'           : property_vector_rational,
    'EPSILON'                            : property_unknown,
    'EQUATIONS'                          : property_unknown,
    'ESSENTIALLY_GENERIC'                : property_bool,
    'EVEN'                               : property_unknown,
    'F2_VECTOR'                          : property_matrix_integer,
    'FACE_SIMPLICITY'                    : property_integer,
    'FACET_DEGREES'                      : property_unknown,
    'FACET_LABELS'                       : property_array_string,
    'FACET_POINT_LATTICE_DISTANCES'      : property_unknown,
    'FACETS'                             : property_sparse_matrix_rational,
    'FACET_SIZES'                        : property_array_int,
    'FACETS_THRU_POINTS'                 : property_unknown,
    'FACETS_THRU_VERTICES'               : property_unknown,
    'FACET_VERTEX_LATTICE_DISTANCES'     : property_matrix_integer,
    'FACET_WIDTH'                        : property_integer,
    'FACET_WIDTHS'                       : property_unknown,
    'FAR_FACE'                           : property_set_int,
    'FAR_HYPERPLANE'                     : property_vector_rational,
    'FATNESS'                            : property_unknown,
    'FEASIBLE'                           : property_bool,
    'FLAG_VECTOR'                        : property_vector_integer,
    'FOLDABLE_COCIRCUIT_EQUATIONS'       : property_unknown,
    'FOLDABLE_MAX_SIGNATURE_UPPER_BOUND' : property_unknown,
    'FTV_CYCLIC_NORMAL'                  : property_unknown,
    'FULL_DIM'                           : property_unknown,
    'F_VECTOR'                           : property_vector_integer,
    'GALE'                               : property_unknown,
    'GALE_TRANSFORM'                     : property_matrix_rational,
    'GALE_VERTICES'                      : property_matrix_float,
    'GORENSTEIN'                         : property_bool,
    'GORENSTEIN_CONE'                    : property_bool,
    'GORENSTEIN_INDEX'                   : property_integer,
    'GORENSTEIN_VECTOR'                  : property_vector_integer,
    'GRAPH'                              : property_graph_undirected,
    'GRAPH_SIGNATURE'                    : property_unknown,
    'GROEBNER_BASIS'                     : property_unknown,
    'GROUP'                              : property_unknown,
    'G_VECTOR'                           : property_unknown,
    'HASSE_DIAGRAM'                      : property_unknown,
    'HILBERT_BASIS'                      : property_unknown,
    'HILBERT_BASIS_GENERATORS'           : property_unknown,
    'HILBERT_SERIES'                     : property_unknown,
    'HOMOGENEOUS'                        : property_unknown,
    'H_STAR_VECTOR'                      : property_unknown,
    'H_VECTOR'                           : property_unknown,
    'INEQUALITIES'                       : property_unknown,
    'INEQUALITIES_THRU_VERTICES'         : property_unknown,
    'INEQUALITY_LABELS'                  : property_unknown,
    'INNER_DESCRIPTION'                  : property_unknown,
    'INPUT_LINEALITY'                    : property_unknown,
    'INTERIOR_LATTICE_POINTS'            : property_unknown,
    'INTERIOR_RIDGE_SIMPLICES'           : property_unknown,
    'LATTICE'                            : property_unknown,
    'LATTICE_BASIS'                      : property_unknown,
    'LATTICE_CODEGREE'                   : property_unknown,
    'LATTICE_DEGREE'                     : property_unknown,
    'LATTICE_EMPTY'                      : property_unknown,
    'LATTICE_POINTS'                     : property_unknown,
    'LATTICE_POINTS_GENERATORS'          : property_unknown,
    'LATTICE_VOLUME'                     : property_unknown,
    'LATTICE_WIDTH'                      : property_unknown,
    'LATTICE_WIDTH_DIRECTION'            : property_unknown,
    'LINEALITY_DIM'                      : property_unknown,
    'LINEALITY_SPACE'                    : property_unknown,
    'LP'                                 : property_unknown,
    'MAX_BOUNDARY_SIMPLICES'             : property_unknown,
    'MAX_INTERIOR_SIMPLICES'             : property_unknown,
    'MINIMAL_NON_FACES'                  : property_unknown,
    'MINIMAL_VERTEX_ANGLE'               : property_unknown,
    'MINKOWSKI_CONE'                     : property_unknown,
    'MINKOWSKI_CONE_COEFF'               : property_unknown,
    'MINKOWSKI_CONE_POINT'               : property_unknown,
    'MOEBIUS_STRIP_EDGES'                : property_unknown,
    'MOEBIUS_STRIP_QUADS'                : property_unknown,
    'MONOID_GRADING'                     : property_unknown,
    'N_01POINTS'                         : property_unknown,
    'N_BOUNDARY_LATTICE_POINTS'          : property_unknown,
    'N_BOUNDED_VERTICES'                 : property_unknown,
    'N_EDGES'                            : property_unknown,
    'NEIGHBOR_FACETS_CYCLIC_NORMAL'      : property_unknown,
    'NEIGHBORLINESS'                     : property_unknown,
    'NEIGHBORLY'                         : property_unknown,
    'NEIGHBOR_VERTICES_CYCLIC_NORMAL'    : property_unknown,
    'N_EQUATIONS'                        : property_unknown,
    'N_FACETS'                           : property_integer,
    'N_FLAGS'                            : property_unknown,
    'N_HILBERT_BASIS'                    : property_unknown,
    'N_INPUT_LINEALITY'                  : property_unknown,
    'N_INTERIOR_LATTICE_POINTS'          : property_unknown,
    'N_LATTICE_POINTS'                   : property_unknown,
    'N_LATTICE_POINTS_IN_DILATION'       : property_unknown,
    'NORMAL'                             : property_unknown,
    'N_POINTS'                           : property_unknown,
    'N_RIDGES'                           : property_unknown,
    'N_VERTEX_FACET_INC'                 : property_unknown,
    'N_VERTICES'                         : property_integer,
    'ONE_VERTEX'                         : property_unknown,
    'OUTER_DESCRIPTION'                  : property_unknown,
    'POINTED'                            : property_unknown,
    'POINT_LABELS'                       : property_unknown,
    'POINTS'                             : property_unknown,
    'POINTS_IN_FACETS'                   : property_unknown,
    'POLAR_SMOOTH'                       : property_unknown,
    'POLYTOPAL_SUBDIVISION'              : property_unknown,
    'POLYTOPE_IN_STD_BASIS'              : property_unknown,
    'POSITIVE'                           : property_unknown,
    'Q_GORENSTEIN_CONE'                  : property_unknown,
    'Q_GORENSTEIN_CONE_INDEX'            : property_unknown,
    'QUOTIENT_SPACE'                     : property_unknown,
    'REFLEXIVE'                          : property_unknown,
    'RELATIVE_VOLUME'                    : property_unknown,
    'REL_INT_POINT'                      : property_unknown,
    'SCHLEGEL'                           : property_unknown,
    'SCHLEGEL_DIAGRAM'                   : property_unknown,
    'SELF_DUAL'                          : property_unknown,
    'SIMPLE'                             : property_bool,
    'SIMPLE_POLYHEDRON'                  : property_unknown,
    'SIMPLEXITY_LOWER_BOUND'             : property_unknown,
    'SIMPLICIAL'                         : property_bool,
    'SIMPLICIAL_CONE'                    : property_unknown,
    'SIMPLICIALITY'                      : property_unknown,
    'SIMPLICITY'                         : property_unknown,
    'SMOOTH'                             : property_unknown,
    'SMOOTH_CONE'                        : property_unknown,
    'SPECIAL_FACETS'                     : property_unknown,
    'SPLIT_COMPATIBILITY_GRAPH'          : property_unknown,
    'SPLITS'                             : property_unknown,
    'SQUARED_RELATIVE_VOLUMES'           : property_unknown,
    'STEINER_POINT'                      : property_unknown,
    'STEINER_POINTS'                     : property_unknown,
    'SUBRIDGE_SIZES'                     : property_unknown,
    'TERMINAL'                           : property_unknown,
    'TILING_LATTICE'                     : property_unknown, 
    'TOWARDS_FAR_FACE'                   : property_unknown,
    'TRIANGLE_FREE'                      : property_unknown,
    'TRIANGULATION'                      : property_unknown,
    'TRIANGULATION_INT'                  : property_unknown,
    'TRIANGULATION_INT_SIGNS'            : property_unknown,
    'TRIANGULATION_SIGNS'                : property_unknown,
    'TWO_FACE_SIZES'                     : property_unknown,
    'UNBOUNDED_FACETS'                   : property_unknown,
    'VALID_POINT'                        : property_unknown,
    'VERTEX_BARYCENTER'                  : property_unknown,
    'VERTEX_DEGREES'                     : property_unknown,
    'VERTEX_LABELS'                      : property_unknown,
    'VERTEX_NORMALS'                     : property_unknown,
    'VERTEX_SIZES'                       : property_unknown,
    'VERTICES'                           : property_matrix_rational,
    'VERTICES_IN_FACETS'                 : property_unknown,
    'VERTICES_IN_INEQUALITIES'           : property_unknown,
    'VERY_AMPLE'                         : property_unknown,
    'VIF_CYCLIC_NORMAL'                  : property_unknown,
    'VISUAL'                             : property_unknown,
    'VISUAL_BOUNDED_GRAPH'               : property_unknown,
    'VISUAL_DUAL'                        : property_unknown,
    'VISUAL_DUAL_FACE_LATTICE'           : property_unknown,
    'VISUAL_DUAL_GRAPH'                  : property_unknown,
    'VISUAL_FACE_LATTICE'                : property_unknown,
    'VISUAL_GRAPH'                       : property_unknown,
    'VISUAL_TRIANGULATION_BOUNDARY'      : property_unknown,
    'VOLUME'                             : property_unknown,
    'WEAKLY_CENTERED'                    : property_unknown,
    'ZONOTOPE_INPUT_POINTS'              : property_unknown,
}

cdef dict graph_properties    = {
    'ADJACENCY'                       : property_unknown,
    'AVERAGE_DEGREE'                  : property_rational,
    'BIPARTITE'                       : property_bool,
    'CHARACTERISTIC_POLYNOMIAL'       : property_unknown,
    'CONNECTED'                       : property_bool,
    'CONNECTED_COMPONENTS'            : property_unknown,
    'CONNECTIVITY'                    : property_integer,
    'DEGREE_SEQUENCE'                 : property_unknown,
    'DIAMETER'                        : property_integer,
    'EDGE_DIRECTIONS'                 : property_unknown,
    'EDGES'                           : property_unknown,
    'LATTICE_ACCUMULATED_EDGE_LENGTHS': property_unknown,
    'LATTICE_EDGE_LENGTHS'            : property_unknown,
    'MAX_CLIQUES'                     : property_unknown,
    'N_CONNECTED_COMPONENTS'          : property_integer,
    'N_EDGES'                         : property_integer,
    'N_NODES'                         : property_integer,
    'NODE_DEGREES'                    : property_unknown,
    'NODE_IN_DEGREES'                 : property_unknown,
    'NODE_LABELS'                     : property_unknown,
    'NODE_OUT_DEGREES'                : property_unknown,
    'SIGNATURE'                       : property_integer,
    'SIGNED_INCIDENCE_MATRIX'         : property_unknown,
    'SQUARED_EDGE_LENGTHS'            : property_unknown,
    'TRIANGLE_FREE'                   : property_bool,
    'VISUAL'                          : property_unknown,
}

cdef dict polymake_properties ={
    property_polytope_rational: polytope_rational_properties,
    property_graph_undirected: graph_properties
}

def handler_generic(perl_object, prop):
    cdef pm_PerlObject * po = (<PerlObject?> perl_object).pm_obj
    cdef pm_PerlObject pm_ans
    pm_get_PerlObject(po.give(prop), pm_ans)
    if not pm_ans.valid():
        raise ValueError("invalid property")
    cdef PerlObject ans = PerlObject.__new__(PerlObject)
    ans.pm_obj = new_PerlObject_from_PerlObject(pm_ans)
    ans.ref = perl_object   # otherwise we easily get errors!
    ans.properties = None   # we should do automatic lookup!
    return ans

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

def handler_polytope_rational(perl_object, prop):
    cdef PerlObject ans = handler_generic(perl_object, prop)
    ans.properties = polytope_rational_properties
    return ans

def handler_graph_undirected(perl_object, prop):
    cdef PerlObject ans = handler_generic(perl_object, prop)
    ans.properties = graph_properties
    return ans

cdef dict handlers = {
    property_unknown          : handler_generic,

    # numbers
    property_bool     : handler_bool,
    property_int      : handler_integer,
    property_integer  : handler_integer,
    property_rational : handler_rational,

    # array, set and vectors
    property_array_int       : handler_generic,
    property_array_string    : handler_generic,
    property_set_int         : handler_generic,
    property_vector_integer  : handler_vector_integer,
    property_vector_rational : handler_generic,

    # matrices
    property_matrix_int             : handler_generic,
    property_matrix_integer         : handler_generic,
    property_matrix_rational        : handler_matrix_rational,
    property_sparse_matrix_rational : handler_generic,

    # others
    property_polytope_rational: handler_polytope_rational,
    property_graph_undirected : handler_graph_undirected
}
