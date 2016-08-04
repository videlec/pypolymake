r"""
Properties of perl objects in polymake

This file defines how perl properties are handled.

.. TODO::

    Make the design flexible enough so that it is possible to redefine how are
    handled properties.
"""
###############################################################################
#       Copyright (C) 2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

cdef pm_type_unknown
cdef pm_type_bool
cdef pm_type_int
cdef pm_type_integer
cdef pm_type_rational

cdef pm_type_array_int
cdef pm_type_array_string
cdef pm_type_set_int

cdef pm_type_vector_integer
cdef pm_type_vector_rational
cdef pm_type_matrix_int
cdef pm_type_matrix_float
cdef pm_type_matrix_integer
cdef pm_type_matrix_rational
cdef pm_type_sparse_matrix_rational

cdef pm_type_polytope_rational
cdef pm_type_quadratic_extension
cdef pm_type_graph_undirected

cdef dict type_properties

cdef dict handlers
