# distutils: language = c++
# distutils: libraries = gmp polymake

from libcpp.string cimport string

cdef extern from "<sstream>" namespace "std":
    cdef cppclass ostringstream:
        string str()

cdef extern from "wrap.h" namespace "polymake":
    void pm_ArrayInt_repr "WRAP_wrap_OUT" (ostringstream, pm_ArrayInt)
    void pm_ArrayString_repr "WRAP_wrap_OUT" (ostringstream, pm_ArrayString)


cdef class GenericArray(object):
    def __iter__(self):
        # TODO: use the iterator and not random access
        for i in range(len(self)):
            yield self[i]

cdef class ArrayInt(GenericArray):
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
        return [self.pm_obj.get(i) for i in range(self.pm_obj.size())]

    sage = python

cdef class ArrayString(GenericArray):
    def __len__(self): return self.pm_obj.size()
    def __getitem__(self, Py_ssize_t i):
        return (<bytes>self.pm_obj.get(i)).decode('ascii')
    def __repr__(self):
        cdef ostringstream out
        pm_ArrayString_repr(out, self.pm_obj)
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
        return [self.pm_obj.get(i) for i in range(self.pm_obj.size())]

