from defs cimport pm_Integer, pm_Rational

cdef class Integer:
    cdef pm_Integer pm_obj

cdef class Rational:
    cdef pm_Rational pm_obj

