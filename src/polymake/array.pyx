cdef class ArrayInt:
    def __getitem__(self, Py_ssize_t i):
        return self.pm_obj.get(i)

    def __repr__(self):
        cdef Py_ssize_t i
        return "[" + ", ".join(str(self.pm_obj.get(i)) for i in range(self.pm_obj.size())) + "]"
