# distutils: language = c++
# distutils: libraries = polymake gmpxx gmp
###############################################################################
#       Copyright (C) 2016 Vincent Delecroix <vincent.delecroix@labri.fr> 
#
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################


include "auto_set.pxi"

from libcpp cimport bool
from libcpp.string cimport string

cdef extern from "<sstream>" namespace "std":
    cdef cppclass ostringstream:
        string str()

cdef extern from "wrap.h" namespace "polymake":
    void pm_SetInt_repr "WRAP_wrap_OUT" (ostringstream, pm_SetInt)

cdef extern from "polymake/Set.h" namespace "polymake":
    cdef cppclass pm_SetInt_iterator "Entire<const Set<int>>::iterator":
        void next "operator++" ()
        bool at_end()
        int get "operator*" ()
    cdef pm_SetInt_iterator entire_SetInt "entire" (pm_SetInt)


cdef class SetInt(object):
    def __len__(self):
        return self.pm_obj.size()
    def __repr__(self):
        cdef ostringstream out
        pm_SetInt_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')
    def __iter__(self):
        cdef pm_SetInt_iterator it = entire_SetInt(self.pm_obj)
        while not it.at_end():
            yield it.get()
            it.next()

