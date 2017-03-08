from defs cimport pm_ArrayInt, pm_ArrayString

cdef class GenericArray(object):
    pass

cdef class ArrayInt(GenericArray):
    cdef pm_ArrayInt pm_obj
cdef class ArrayString(GenericArray):
    cdef pm_ArrayString pm_obj
