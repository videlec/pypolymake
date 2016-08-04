###############################################################################
#       Copyright (C) 2011-2012 Burcin Erocal <burcin@erocal.org>
#                     2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from .defs cimport pm_PerlObject

cdef PerlObject wrap_perl_object(pm_PerlObject pm_obj)

cdef class PerlObject:
    cdef pm_PerlObject * pm_obj  # underlying perl object
    cdef ref                     # reference to other perl object
    cdef dict properties        # dictionary of polymake properties

