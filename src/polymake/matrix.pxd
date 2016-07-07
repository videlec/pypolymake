from defs cimport pm_MatrixRational

cdef class MatrixRational:
    cdef pm_MatrixRational pm_obj

cdef pm_MatrixRational* mat_to_pm(mat)
