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

cpdef get_property_handler(bytes)
cpdef get_method_handler(bytes)

cdef dict handlers
