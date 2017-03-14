# distutils: language = c++
# distutils: libraries = polymake gmpxx gmp
###############################################################################
#       Copyright (C) 2017      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from libcpp.string cimport string

from .defs cimport pm_PairStringString, pm_PairStringArrayString, pm_SetInt
from .set cimport SetInt

cdef extern from "<sstream>" namespace "std":
    cdef cppclass ostringstream:
        string str()

cdef extern from "wrap.h" namespace "polymake":
    void pm_ArrayBool_repr "WRAP_wrap_OUT" (ostringstream, pm_ArrayBool)
    void pm_ArrayInt_repr "WRAP_wrap_OUT" (ostringstream, pm_ArrayInt)
    void pm_ArrayString_repr "WRAP_wrap_OUT" (ostringstream, pm_ArrayString)
    void pm_ArraySetInt_repr "WRAP_wrap_OUT" (ostringstream, pm_ArraySetInt)
    void pm_ArrayArrayInt_repr "WRAP_wrap_OUT" (ostringstream, pm_ArrayArrayInt)
    void pm_ArrayArrayString_repr "WRAP_wrap_OUT" (ostringstream, pm_ArrayArrayString)
    void pm_ArrayPairStringString_repr "WRAP_wrap_OUT" (ostringstream, pm_ArrayPairStringString)
    void pm_ArrayPairStringArrayString_repr "WRAP_wrap_OUT" (ostringstream, pm_ArrayPairStringArrayString)
    void pm_ArrayArrayPairStringString_repr "WRAP_wrap_OUT" (ostringstream, pm_ArrayArrayPairStringString)


#    def __iter__(self):
#        # TODO: use the iterator and not random access
#        for i in range(len(self)):
#            yield self[i]
#
#
#    sage = python

cdef class ArrayBool(object):
    def __len__(self): return self.pm_obj.size()
    def __getitem__(self, Py_ssize_t i): return self.pm_obj.get(i)
    def __repr__(self):
        cdef ostringstream out
        pm_ArrayBool_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')
    def python(self):
        r"""Converts into a list of booleans
        """
        return [self[i] for i in range(len(self))]

cdef class ArrayInt(object):
    def __len__(self): return self.pm_obj.size()
    def __getitem__(self, Py_ssize_t i): return self.pm_obj.get(i)
    def __repr__(self):
        cdef ostringstream out
        pm_ArrayInt_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')
    def python(self):
        r"""Converts into a Python list of integers

        >>> import polymake
        >>> p = polymake.cube(3)
        >>> type(c)
        <type 'polymake.array.ArrayInt'>
        >>> c.python()
        [7, 6, 5, 4, 3, 2, 1, 0]
        """
        return [self[i] for i in range(len(self))]

cdef class ArrayString(object):
    def __len__(self): return self.pm_obj.size()
    def __getitem__(self, Py_ssize_t i):
        return (<bytes>self.pm_obj.get(i)).decode('ascii')
    def __repr__(self):
        cdef ostringstream out
        pm_ArrayString_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')
    def python(self):
        r"""Converts into a list of strings

        >>> import polymake
        >>> p = polymake.cube(3)
        >>> type(c)
        <type 'polymake.array.ArrayInt'>
        >>> c.python()
        [7, 6, 5, 4, 3, 2, 1, 0]
        """
        return [self[i] for i in range(len(self))]

cdef class ArraySetInt(object):
    r"""
    Array of sets of integers

    EXAMPLES:

    >>> import polymake
    >>> c = polymake.cube(3,2,0)
    """
    def __len__(self): return self.pm_obj.size()
    def __getitem__(self, Py_ssize_t i):
        cdef SetInt s = SetInt.__new__(SetInt)
        s.pm_obj = self.pm_obj.get(i)
        return s
    def __repr__(self):
        cdef ostringstream out
        pm_ArraySetInt_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')

cdef class ArrayArrayInt(object):
    def __len__(self): return self.pm_obj.size()
    def __getitem__(self, Py_ssize_t i):
        cdef ArrayInt a = ArrayInt.__new__(ArrayInt)
        a.pm_obj = self.pm_obj.get(i)
        return a
    def __repr__(self):
        cdef ostringstream out
        pm_ArrayArrayInt_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')

cdef class ArrayArrayString(object):
    def __len__(self): return self.pm_obj.size()
    def __getitem__(self, Py_ssize_t i):
        cdef ArrayString a = ArrayString.__new__(ArrayString)
        a.pm_obj = self.pm_obj.get(i)
        return a
    def __repr__(self):
        cdef ostringstream out
        pm_ArrayArrayString_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')
    def python(self):
        r"""Converts into a list of list of strings
        """
        return [self[i].python() for i in range(len(self))]


cdef class ArrayPairStringString(object):
    def __len__(self): return self.pm_obj.size()
    def __getitem__(self, Py_ssize_t i):
        cdef pm_PairStringString x = self.pm_obj.get(i)
        return (x.first, x.second)
    def __repr__(self):
        cdef ostringstream out
        pm_ArrayPairStringString_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')
    def python(self):
        cdef Py_ssize_t i
        return [self[i] for i in range(self.pm_obj.size())]

cdef class ArrayPairStringArrayString(object):
    def __len__(self): return self.pm_obj.size()
    def __getitem__(self, Py_ssize_t i):
        cdef pm_PairStringArrayString x = self.pm_obj.get(i)
        cdef ArrayString y = ArrayString.__new__(ArrayString)
        y.pm_obj = x.second
        return (x.first, y)
    def __repr__(self):
        cdef ostringstream out
        pm_ArrayPairStringArrayString_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')
    def python(self):
        cdef Py_ssize_t i
        l = [self[i] for i in range(self.pm_obj.size())]
        return [(x, y.python()) for x,y in l]

cdef class ArrayArrayPairStringString(object):
    def __len__(self): return self.pm_obj.size()
    def __getitem__(self, Py_ssize_t i):
        cdef ArrayPairStringString a = ArrayPairStringString.__new__(ArrayPairStringString)
        a.pm_obj = self.pm_obj.get(i)
        return a
    def __repr__(self):
        cdef ostringstream out
        pm_ArrayArrayPairStringString_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')
    def python(self):
        cdef Py_ssize_t i
        return [self[i].python() for i in range(self.pm_obj.size())]
