# distutils: language = c++
# distutils: libraries = gmp polymake

from libcpp.string cimport string

cdef extern from "<sstream>" namespace "std":
    cdef cppclass ostringstream:
        string str()

cdef extern from "wrap.h" namespace "polymake":
    void pm_ArrayBool_repr "WRAP_wrap_OUT" (ostringstream, pm_ArrayBool)
    void pm_ArrayInt_repr "WRAP_wrap_OUT" (ostringstream, pm_ArrayInt)
    void pm_ArrayString_repr "WRAP_wrap_OUT" (ostringstream, pm_ArrayString)
    void pm_ArraySetInt_repr "WRAP_wrap_OUT" (ostringstream, pm_ArraySetInt)
    void pm_ArrayArrayInt_repr "WRAP_wrap_OUT" (ostringstream, pm_ArrayArrayInt)

cdef class GenericArray(object):
    def __iter__(self):
        # TODO: use the iterator and not random access
        for i in range(len(self)):
            yield self[i]

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

    sage = python

cdef class ArrayBool(GenericArray):
    def __len__(self): return self.pm_obj.size()
    def __getitem__(self, Py_ssize_t i): return self.pm_obj.get(i)
    def __repr__(self):
        cdef ostringstream out
        pm_ArrayBool_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')

cdef class ArrayInt(GenericArray):
    def __len__(self): return self.pm_obj.size()
    def __getitem__(self, Py_ssize_t i): return self.pm_obj.get(i)
    def __repr__(self):
        cdef ostringstream out
        pm_ArrayInt_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')

cdef class ArrayString(GenericArray):
    def __len__(self): return self.pm_obj.size()
    def __getitem__(self, Py_ssize_t i):
        return (<bytes>self.pm_obj.get(i)).decode('ascii')
    def __repr__(self):
        cdef ostringstream out
        pm_ArrayString_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')

cdef class ArraySetInt(GenericArray):
    def __len__(self): return self.pm_obj.size()
    def __getitem__(self, Py_ssize_t i):
        raise NotImplementedError
    def __repr__(self):
        cdef ostringstream out
        pm_ArraySetInt_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')

cdef class ArrayArrayInt(GenericArray):
    def __len__(self): return self.pm_obj.size()
    def __getitem__(self, Py_ssize_t i):
        cdef ArrayInt a = ArrayInt.__new__(ArrayInt)
        a.pm_obj = self.pm_obj.get(i)
        return a
    def __repr__(self):
        cdef ostringstream out
        pm_ArrayArrayInt_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')

