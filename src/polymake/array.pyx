
cdef class ArrayInt:
    def __len__(self):
        return self.pm_obj.size()

    def __getitem__(self, Py_ssize_t i):
        return self.pm_obj.get(i)

    def __repr__(self):
        cdef Py_ssize_t i
        return "[" + ", ".join(str(self.pm_obj.get(i)) for i in range(self.pm_obj.size())) + "]"

    def __iter__(self):
        # TODO: use the iterator and not random access
        for i in range(self.pm_obj.size()):
            yield self.pm_obj.get(i)

    def python(self):
        r"""Converts into a Python list of integers

        >>> import polymake
        >>> p = polymake.cube(3)
        >>> type(c)
        <type 'polymake.array.ArrayInt'>
        >>> c.python()
        [7, 6, 5, 4, 3, 2, 1, 0]
        """
        return [self.pm_obj.get(i) for i in range(self.pm_obj.size())]

    sage = python
