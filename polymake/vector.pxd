
from libcpp cimport bool
from libcpp.string cimport string

from .defs cimport pm_Integer, pm_Rational

cdef VectorInt(object):
    cdef pm_Vector[int] pm_obj

cdef VectorFloat(object):
    cdef pm_Vector[float] pm_obj

cdef VectorInteger(object):
    cdef pm_Vector[pm_Integer] pm_obj

cdef VectorRational(object):
    cdef pm_Vector[pm_Rational] pm_obj
