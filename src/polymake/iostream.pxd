cdef extern from "<iostream>" namespace "std":
    cdef cppclass ostream:
        ostream& write(const char*, int) except +

cdef extern from "<iostream>" namespace "std::ios_base":
    cdef cppclass open_mode:
        pass
    cdef open_mode binary

cdef extern from "<fstream>" namespace "std":
    cdef cppclass ofstream(ostream):
    # constructors
        ofstream(const char*) except +
        ofstream(const char*, open_mode) except+
