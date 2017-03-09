# distutils: language = c++

from libcpp cimport bool
from libcpp.string cimport string

from .number cimport Integer, Rational

cdef extern from "<utility>":
    cdef cppclass pairstringstring "std::pair<std::string, std::string>":
        string first
        string second
    cdef cppclass pairintint "std::pair<int,int>":
        int first
        int second

cdef extern from "<sstream>" namespace "std":
    cdef cppclass ostringstream:
        string str()

cdef extern from "polymake/Map.h" namespace "polymake":
    cdef cppclass pm_MapStringString_iterator "Entire<const Map<std::string,std::string>>::iterator":
        void next "operator++" ()
        bool at_end()
        pairstringstring get "operator*" ()

    cdef cppclass pm_MapIntInt_iterator "Entire<const Map<int,int>>::iterator":
        void next "operator++" ()
        bool at_end()
        pairintint get "operator*" ()

    cdef pm_MapStringString_iterator entire_MapStringString "entire" (pm_MapStringString)
    cdef pm_MapIntInt_iterator entire_MapIntInt "entire" (pm_MapIntInt)

cdef extern from "wrap.h" namespace "polymake":
    void pm_MapStringString_repr "WRAP_wrap_OUT" (ostringstream, pm_MapStringString)
    void pm_MapRationalRational_repr "WRAP_wrap_OUT" (ostringstream, pm_MapRationalRational)
    void pm_MapIntInt_repr "WRAP_wrap_OUT" (ostringstream, pm_MapIntInt)
    void pm_MapIntegerInt_repr "WRAP_wrap_OUT" (ostringstream, pm_MapIntegerInt)

cdef class MapStringString:
    def __repr__(self):
        cdef ostringstream out
        pm_MapStringString_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')

    def __getitem__(self, bytes key):
        return self.pm_obj.get(key)

    def __len__(self):
        return self.pm_obj.size()

    def __iter__(self):
        cdef pm_MapStringString_iterator it = entire_MapStringString(self.pm_obj)
        while not it.at_end():
            yield it.get().first
            it.next()

    def __contains__(self, bytes key):
        return self.pm_obj.exists(key)

    def items(self):
        "Iterator throug the pairs (key, value) of this map"
        cdef pm_MapStringString_iterator it = entire_MapStringString(self.pm_obj)
        while not it.at_end():
            yield (it.get().first, it.get().second)
            it.next()


    def keys(self):
        "Iterator throug the keys of this map"
        cdef pm_MapStringString_iterator it = entire_MapStringString(self.pm_obj)
        while not it.at_end():
            yield it.get().first
            it.next()

    def values(self):
        "Iterator throug the values of this map"
        cdef pm_MapStringString_iterator it = entire_MapStringString(self.pm_obj)
        while not it.at_end():
            yield it.get().second
            it.next()

    def python(self):
        return dict(self.items())


cdef class MapIntInt:
    def __repr__(self):
        cdef ostringstream out
        pm_MapIntInt_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')

    def __getitem__(self, int key):
        return self.pm_obj.get(key)

    def __len__(self):
        return self.pm_obj.size()

    def __iter__(self):
        cdef pm_MapIntInt_iterator it = entire_MapIntInt(self.pm_obj)
        while not it.at_end():
            yield it.get().first
            it.next()

    def __contains__(self, int key):
        r"""
        TESTS:

        >>> import polymake
        >>> c = polymake.associahedron(3)
        >>> m = c.TWO_FACE_SIZES
        >>> 4 in m
        True
        >>> 5 in m
        True
        >>> 2 in m
        False
        >>> 'a' in m
        Traceback (most recent call last):
        ...
        TypeError: an integer is required
        """
        return self.pm_obj.exists(key)

    def items(self):
        "Iterator throug the pairs (key, value) of this map"
        cdef pm_MapIntInt_iterator it = entire_MapIntInt(self.pm_obj)
        while not it.at_end():
            yield (it.get().first, it.get().second)
            it.next()

    def keys(self):
        "Iterator throug the keys of this map"
        cdef pm_MapIntInt_iterator it = entire_MapIntInt(self.pm_obj)
        while not it.at_end():
            yield it.get().first
            it.next()

    def values(self):
        "Iterator throug the values of this map"
        cdef pm_MapIntInt_iterator it = entire_MapIntInt(self.pm_obj)
        while not it.at_end():
            yield it.get().second
            it.next()

    def python(self):
        return dict(self.items())


cdef class MapRationalRational:
    def __repr__(self):
        cdef ostringstream out
        pm_MapRationalRational_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')

    def __getitem__(self, Rational key):
        cdef Rational out = Rational.__new__(Rational)
        out.pm_obj = self.pm_obj.get(key.pm_obj)
        return out

    def __len__(self):
        return self.pm_obj.size()

    def __contains__(self, Rational key):
        r"""
        TESTS:

        >>> import polymake
        >>> c = polymake.associahedron(3)
        >>> m = c.RELATIVE_VOLUME
        >>> polymake.Rational(805,1) in m
        True
        >>> polymake.Rational(805,2) in m
        False
        """
        return self.pm_obj.exists(key.pm_obj)


cdef class MapIntegerInt:
    def __repr__(self):
        cdef ostringstream out
        pm_MapIntegerInt_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')

    def __getitem__(self, Integer key):
        return self.pm_obj.get(key.pm_obj)

    def __len__(self):
        return self.pm_obj.size()

    def __contains__(self, Integer key):
        return self.pm_obj.exists(key.pm_obj)

