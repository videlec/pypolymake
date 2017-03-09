from .defs cimport (pm_MapStringString, pm_MapRationalRational, pm_MapIntInt,
        pm_MapIntegerInt)

cdef class MapStringString:
    cdef pm_MapStringString pm_obj
cdef class MapRationalRational:
    cdef pm_MapRationalRational pm_obj
cdef class MapIntInt:
    cdef pm_MapIntInt pm_obj
cdef class MapIntegerInt:
    cdef pm_MapIntegerInt pm_obj
