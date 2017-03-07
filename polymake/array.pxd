from defs cimport pm_ArrayInt, pm_ArrayString

from libcpp.string cimport string

cdef class ArrayInt:
    cdef pm_ArrayInt pm_obj
