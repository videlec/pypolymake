# distutils: language = c++
# distutils: libraries = polymake
###############################################################################
#       Copyright (C) 2011-2012 Burcin Erocal <burcin@erocal.org>
#                     2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

# properly initialize the Main
# FIXME: pass user-settings parameter?
cdef Main * pm = new Main("@interactive")

def pm_set_application(bytes s):
    pm.set_application(s)

def pm_include(bytes s):
    pm.pm_include(s)
