###############################################################################
#       Copyright (C) 2011-2012 Burcin Erocal <burcin@erocal.org>
#                     2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from .defs cimport pm_PerlObject, pm_MapStringString

cdef class PerlObject:
    cdef pm_PerlObject * pm_obj       # underlying perl object
    cdef ref                          # reference to other perl object
    cdef dict properties              # polymake properties
    cdef dict methods                 # polymake methods

cdef PerlObject wrap_perl_object(pm_PerlObject pm_obj)

cdef pm_MapStringString pm_get_properties(pm_PerlObject * p)
cdef pm_MapStringString pm_get_methods(pm_PerlObject *p)

