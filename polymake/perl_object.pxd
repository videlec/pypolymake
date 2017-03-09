###############################################################################
#       Copyright (C) 2011-2012 Burcin Erocal <burcin@erocal.org>
#                     2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from .defs cimport (Main, pm_PerlObject)

cdef PerlObject wrap_perl_object(pm_PerlObject pm_obj)

# FIXME: pass user-settings parameter
cdef Main pm

#from .map cimport MapStringString
# FIXME: properties should be declared as MapStringString
# but the python shell complains at execution with
# ImportError: ... map.cpython-36m-x86_64-linux-gnu.so: undefined symbol: _ZN2pm21shared_object_secrets9empty_repE

cdef class PerlObject:
    cdef pm_PerlObject * pm_obj       # underlying perl object
    cdef ref                          # reference to other perl object
    cdef properties   # map of polymake properties

