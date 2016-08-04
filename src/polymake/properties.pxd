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

cdef property_unknown
cdef property_bool
cdef property_integer
cdef property_rational
cdef property_vector_integer
cdef property_matrix_rational
cdef property_polytope_rational
cdef property_graph_undirected

cdef dict polytope_rational_properties
cdef dict graph_properties

cdef dict handlers
