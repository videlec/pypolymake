# distutils: language = c++
# distutils: libraries = polymake gmpxx gmp
###############################################################################
#       Copyright (C) 2016 Vincent Delecroix <vincent.delecroix@labri.fr> 
#
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from cpython.object cimport Py_LT, Py_LE, Py_EQ, Py_NE, Py_GT, Py_GE

from .cygmp.types cimport mpz_t, mpq_t, mpz_srcptr, mpq_srcptr
from .cygmp.mpz cimport mpz_init, mpz_clear, mpz_set_si
from .cygmp.mpq cimport mpq_init, mpq_clear, mpq_numref, mpq_denref, mpq_canonicalize
from .cygmp.utils cimport mpz_set_pylong, mpz_get_bytes, mpq_get_bytes

from libcpp.string cimport string

from .defs cimport pm_Integer
from .integer cimport Integer

cdef extern from "<sstream>" namespace "std":
    cdef cppclass ostringstream:
        string str()

cdef extern from "wrap.h" namespace "polymake":
    void pm_Rational_repr "WRAP_wrap_OUT" (ostringstream, pm_Rational)

def get_num_den(elt):
    num = None
    den = None
    try:
        num = elt.numerator
        den = elt.denominator
    except AttributeError:
        try:
            num, den = elt
        except (TypeError, ValueError):
            pass

    if callable(num) and callable(den):
        num = num()
        den = den()
    if not isinstance(num, (int,long)) or not isinstance(den, (int,long)):
        num = int(num)
        den = int(den)

    return (num, den)

cdef class Rational(object):
    r"""Polymake rational
    """
    def __init__(self, num, den=None):
        if den is None:
            num, den = get_num_den(num)

        if not den:
            raise ValueError("denominator must not be zero")

        cdef mpq_t z
        mpq_init(z)
        if isinstance(num, int):
            mpz_set_si(mpq_numref(z), <int>num)
        elif isinstance(num, long):
            mpz_set_pylong(mpq_numref(z), num)
        else:
            raise ValueError("Polymake integer can only be initialized from Python int and long")
        if isinstance(den, int):
            mpz_set_si(mpq_denref(z), <int>den)
        elif isinstance(num, long):
            mpz_set_pylong(mpq_denref(z), den)

        mpq_canonicalize(z)
        self.pm_obj.set_mpq_srcptr(<mpq_srcptr>z)
        mpq_clear(z)

    def sage(self):
        r"""Converts rational to Sage

        >>> import polymake
        >>> import polymake
        >>> a = polymake.Rational(23, 55)
        >>> a
        23/55
        >>> a.sage()
        23/55
        >>> type(a.sage())
        <type 'sage.rings.rational.Rational'>

        >>> a = polymake.Rational(2**100, 3**100)
        >>> a.sage()
        1267650600228229401496703205376/515377520732011331036461129765621272702107522001
        """
        from .sage_conversion import Rational_to_sage
        return Rational_to_sage(self)

    _rational_ = sage

    def python(self):
        r"""Converts to a python fraction

        >>> import polymake
        >>> c = polymake.Rational(12, 5)
        """
        from fractions import Fraction
        return Fraction(self.numerator().python(), self.denominator().python())

    def __nonzero__(self):
        return not self.pm_obj.is_zero()

    def __richcmp__(self, other, op):
        cdef int c

        if type(self) is type(other):
            c = (<Rational>self).pm_obj.compare((<Rational>other).pm_obj)
        elif isinstance(self, Integer):
            c = (<Rational>other).pm_obj.compare((<Integer>self).pm_obj)
        elif isinstance(other, Integer):
            c = (<Rational>self).pm_obj.compare((<Integer>other).pm_obj)
        elif isinstance(self, int):
            c = (<Rational>other).pm_obj.compare(<long>self)
        elif isinstance(other, int):
            c = (<Rational>self).pm_obj.compare(<long>other)
        else:
           return NotImplemented

        if c < 0:
            return op in (Py_LE, Py_LT, Py_NE)
        elif c == 0:
            return op in (Py_LE, Py_EQ, Py_GE)
        else:
            return op in (Py_GE, Py_GT, Py_NE)

    def __repr__(self):
        cdef ostringstream out
        pm_Rational_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')

    def numerator(self):
        cdef Integer ans = Integer.__new__(Integer)
        cdef mpq_srcptr z = self.pm_obj.get_rep()
        ans.pm_obj.set_mpz_srcptr(mpq_numref(z))
        return ans

    def denominator(self):
        cdef Integer ans = Integer.__new__(Integer)
        cdef mpq_srcptr z = self.pm_obj.get_rep()
        ans.pm_obj.set_mpz_srcptr(mpq_denref(z))
        return ans

    def __add__(self, other):
        cdef Rational ans = Rational.__new__(Rational)
        if type(self) is type(other):
            ans.pm_obj = (<Rational>self).pm_obj + (<Rational>other).pm_obj
        elif type(self) is Integer:
            ans.pm_obj = (<Rational>other).pm_obj + (<Integer>self).pm_obj
        elif type(other) is Integer:
            ans.pm_obj = (<Rational>self).pm_obj + (<Integer>other).pm_obj
        elif isinstance(self, int):
            ans.pm_obj = (<Rational>other).pm_obj + <long>self
        elif isinstance(other, int):
            ans.pm_obj = (<Rational>self).pm_obj + <long>other
        else:
            return NotImplemented
        return ans

    def __sub__(self, other):
        cdef Rational ans = Rational.__new__(Rational)
        if type(self) is type(other):
            ans.pm_obj = (<Rational>self).pm_obj - (<Rational>other).pm_obj
        elif type(self) is Integer:
            ans.pm_obj = -((<Rational>other).pm_obj - (<Integer>self).pm_obj)
        elif type(other) is Integer:
            ans.pm_obj = (<Rational>self).pm_obj - (<Integer>other).pm_obj
        elif isinstance(self, int):
            ans.pm_obj = -((<Rational>other).pm_obj - <long>self)
        elif isinstance(other, int):
            ans.pm_obj = (<Rational>self).pm_obj - <long>other
        else:
            return NotImplemented
        return ans

    def __mul__(self, other):
        cdef Rational ans = Rational.__new__(Rational)
        if type(self) is type(other):
            ans.pm_obj = (<Rational>self).pm_obj * (<Rational>other).pm_obj
        elif type(self) is Integer:
            ans.pm_obj = (<Rational>other).pm_obj * (<Integer>self).pm_obj
        elif type(other) is Integer:
            ans.pm_obj = (<Rational>self).pm_obj * (<Integer>other).pm_obj
        elif isinstance(self, int):
            ans.pm_obj = (<Rational>other).pm_obj * <long>self
        elif isinstance(other, int):
            ans.pm_obj = (<Rational>self).pm_obj * <long>other
        else:
            return NotImplemented
        return ans


    def __truediv__(self, other):
        if not other:
            raise ZeroDivisionError("polymake.number.Rational division by zero")

        cdef Rational ans = Rational.__new__(Rational)
        if type(self) is type(other):
            ans.pm_obj = (<Rational>self).pm_obj / (<Rational>other).pm_obj
        elif type(other) is Integer:
            ans.pm_obj = (<Rational>self).pm_obj / (<Integer>other).pm_obj
        elif isinstance(other, int):
            ans.pm_obj = (<Rational>self).pm_obj / <long>other
        else:
            if not type(self) is Rational:
                try:
                    return Rational(self) / <Rational>other
                except (ValueError,TypeError):
                    pass
            return NotImplemented
        return ans

    def __div__(self, other):
        return self.__truediv__(other)

