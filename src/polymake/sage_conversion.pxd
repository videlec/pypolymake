from .defs cimport (pm_Integer, pm_Rational, pm_ArrayInt,
    pm_SetInt, pm_MatrixRational, pm_MatrixInt, pm_MatrixInteger, pm_MatrixRational,
    pm_VectorInteger, pm_VectorRational)

cdef pm_Integer_to_sage(pm_Integer n)
cdef pm_Rational_to_sage(pm_Rational n)
cdef pm_SetInt_to_sage(pm_SetInt a)
cdef pm_VectorInteger_to_sage(pm_VectorInteger v)
cdef pm_VectorRational_to_sage(pm_VectorRational v)
cdef pm_MatrixInt_to_sage(pm_MatrixInt m)
cdef pm_MatrixInteger_to_sage(pm_MatrixInteger m)
cdef pm_MatrixRational_to_sage(pm_MatrixRational m)

