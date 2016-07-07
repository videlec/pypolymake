###############################################################################
#       Copyright (C) 2011-2012 Burcin Erocal <burcin@erocal.org>
#                     2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 2 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from .number cimport Integer

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


