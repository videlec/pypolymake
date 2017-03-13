# distutils: language = c++
# distutils: libraries = polymake gmpxx gmp
###############################################################################
#       Copyright (C) 2011-2012 Burcin Erocal <burcin@erocal.org>
#                     2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from libcpp.string cimport string

from .defs cimport pm_ArrayString, pm_ArrayArrayPairStringString
from .array cimport ArrayString, ArrayArrayPairStringString

# properly initialize the Main
# FIXME: pass user-settings parameter?
cdef Main * pm = new Main("@interactive")
pm.set_application(b"polytope")
pm.pm_include(b"common::sage.rules")

cdef list apps = [b"common", b"fulton", b"group", b"matroid", b"topaz",
    b"fan", b"graph", b"ideal", b"polytope", b"tropical"]

def pm_set_application(bytes s):
    pm.set_application(s)

def pm_include(bytes s):
    pm.pm_include(s)

cdef extern from "polymake/client.h" namespace "polymake":
    pm_ArrayString call_it "call_function" (string) except +

def functions_in_current_application():
    cdef ArrayString s = ArrayString.__new__(ArrayString)
    s.pm_obj = call_it(<string> "Sage::functions_for_object")
    return s.python()

cdef extern from "polymake/client.h" namespace "polymake":
    pm_ArrayArrayPairStringString call_it2 "call_function" (string, string) except +

def arguments(bytes fname):
    r"""
    Return a list of list of pairs of strings.
    """
    cdef ArrayArrayPairStringString a = ArrayArrayPairStringString.__new__(ArrayArrayPairStringString)
    a.pm_obj = call_it2(<string> "Sage::arguments", <string> fname)
    return a.python()

