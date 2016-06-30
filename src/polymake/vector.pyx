# distutils: language = c++
# distutils: libraries = polymake gmp xml2 perl

###############################################################################
#       Copyright (C) 2011-2012 Burcin Erocal <burcin@erocal.org>
#                     2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 2 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from libc.stdlib cimport malloc, free

from defs cimport Main, pm_PerlObject, pm_MatrixRational, pm_Rational, pm_Integer, \
        pm_VectorInteger
from defs cimport CallPolymakeFunction, CallPolymakeFunction1, \
        CallPolymakeFunction2, CallPolymakeFunction3, \
        new_PerlObject_from_PerlObject
from defs cimport pm_get_Integer, pm_get_MatrixRational, pm_get_PerlObject, \
        pm_get_VectorInteger, \
        pm_assign_MatrixRational, get_element


from .number cimport Integer, Rational

cdef class VectorInteger:
    def __len__(self):
        return self.pm_obj.size()

    def __getitem__(self, _i):
        cdef Py_ssize_t size = self.pm_obj.size()
        cdef Py_ssize_t i = <Py_ssize_t?> _i

        if not (0 <= i < size):
            raise IndexError("integer vector out of range")

        cdef Integer ans = Integer.__new__(Integer)
        ans.pm_obj.set(self.pm_obj.get(i).get_rep())
        return ans

    def __repr__(self):
        return "(" + ", ".join(str(x) for x in self) + ")"


