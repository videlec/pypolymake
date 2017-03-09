from defs cimport (pm_ArrayBool, pm_ArrayInt,
        pm_ArrayString, pm_ArraySetInt, pm_ArrayArrayInt)

cdef class GenericArray(object):
    pass

cdef class ArrayBool(GenericArray):
    cdef pm_ArrayBool pm_obj
cdef class ArrayInt(GenericArray):
    cdef pm_ArrayInt pm_obj
cdef class ArrayString(GenericArray):
    cdef pm_ArrayString pm_obj
cdef class ArraySetInt(GenericArray):
    cdef pm_ArraySetInt pm_obj
cdef class ArrayArrayInt(GenericArray):
    cdef pm_ArrayArrayInt pm_obj
