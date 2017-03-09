# distutils: language = c++
# distutils: libraries = gmp polymake
###############################################################################
#       Copyright (C) 2011-2012 Burcin Erocal <burcin@erocal.org>
#                     2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from .number cimport Integer, Rational

from libcpp.string cimport string

cdef extern from "<sstream>" namespace "std":
    cdef cppclass ostringstream:
        string str()

cdef extern from "wrap.h" namespace "polymake":
    void pm_VectorInteger_repr "WRAP_wrap_OUT" (ostringstream, pm_VectorInteger)
    void pm_VectorRational_repr "WRAP_wrap_OUT" (ostringstream, pm_VectorRational)


cdef class VectorInteger:
    def __len__(self):
        return self.pm_obj.size()

    def __getitem__(self, _i):
        cdef Py_ssize_t size = self.pm_obj.size()
        cdef Py_ssize_t i = <Py_ssize_t?> _i

        if not (0 <= i < size):
            raise IndexError("integer vector out of range")

        cdef Integer ans = Integer.__new__(Integer)
        ans.pm_obj.set_mpz_srcptr(self.pm_obj.get(i).get_rep())
        return ans

    def __repr__(self):
        cdef ostringstream out
        pm_VectorInteger_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')

    def python(self):
        return [x.python() for x in self]

    def sage(self):
        r"""
        Convert to a Sage integer vector

        >>> import polymake
        >>> p = polymake.cube(3)
        >>> v = p.CD_INDEX
        >>> v = p.CD_INDEX_COEFFICIENTS
        >>> v.sage()
        (1, 4, 6)
        >>> type(v.sage())
        <type 'sage.modules.vector_integer_dense.Vector_integer_dense'>
        """
        from .sage_conversion import VectorInteger_to_sage
        return VectorInteger_to_sage(self)

cdef class VectorRational:
    def __len__(self):
        return self.pm_obj.size()

    def __getitem__(self, _i):
        cdef Py_ssize_t size = self.pm_obj.size()
        cdef Py_ssize_t i = <Py_ssize_t?> _i

        if not (0 <= i < size):
            raise IndexError("integer vector out of range")

        cdef Rational ans = Rational.__new__(Rational)
        ans.pm_obj.set_mpq_srcptr(self.pm_obj.get(i).get_rep())
        return ans

    def __repr__(self):
        cdef ostringstream out
        pm_VectorRational_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')

    def python(self):
        return [x.python() for x in self]

    def sage(self):
        r"""
        Convert to a Sage rational vector

        >>> import polymake
        >>> p = polymake.cube(3)
        >>> v = p.CENTROID
        >>> v
        (1, 0, 0, 0)
        >>> v.sage()
        (1, 0, 0, 0)
        >>> type(v.sage())
        <type 'sage.modules.vector_rational_dense.Vector_rational_dense'>
        """
        from .sage_conversion import VectorRational_to_sage
        return VectorRational_to_sage(self)
