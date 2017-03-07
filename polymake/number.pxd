###############################################################################
#       Copyright (C) 2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from defs cimport pm_Integer, pm_Rational

cdef class Integer:
    cdef pm_Integer pm_obj

cdef class Rational:
    cdef pm_Rational pm_obj

