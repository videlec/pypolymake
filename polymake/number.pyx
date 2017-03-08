# distutils: language = c++
# distutils: libraries = gmp polymake
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

cdef extern from "<sstream>" namespace "std":
    cdef cppclass ostringstream:
        string str()

cdef extern from "wrap.h" namespace "polymake":
    void pm_Integer_repr "WRAP_wrap_OUT" (ostringstream, pm_Integer)
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


cdef class Integer:
    r"""Polymake integer
    """
    def __init__(self, data):
        cdef mpz_t z

        if isinstance(data, int):
            mpz_init(z)
            mpz_set_si(z, data)
        elif isinstance(data, long):
            mpz_init(z)
            mpz_set_pylong(z, data)
        else:
            raise ValueError("Polymake integer can only be initialized from Python int and long")

        self.pm_obj.set_mpz_srcptr(<mpz_srcptr>z)
        mpz_clear(z)

    def _integer_(self, R=None):
        r"""Conversion to Sage integer

        Overflow currently causes a segmentation fault!
        
        >>> import polymake
        >>> from sage.all import ZZ
        >>> a = polymake.Integer(2r**100r)
        >>> ZZ(a)
        1267650600228229401496703205376
        """
        return R(self.sage())

    def __nonzero__(self):
        return not self.pm_obj.is_zero()

    def __repr__(self):
        cdef ostringstream out
        pm_Integer_repr(out, self.pm_obj)
        return (<bytes>out.str()).decode('ascii')

    #TODO: overflow!!
    def __int__(self):
        return <int> self.pm_obj

    python = __int__

    def __float__(self):
        return <double> self.pm_obj

    def __richcmp__(self, other, op):
        cdef int c

        if type(self) is type(other):
            c = (<Integer>self).pm_obj.compare((<Integer>other).pm_obj)
        elif isinstance(self, int):
            c = -(<Integer>other).pm_obj.compare(<long>self)
        elif isinstance(other, int):
            c = (<Integer>self).pm_obj.compare(<long>other)
        else:
           return NotImplemented

        if c < 0:
            return op in (Py_LE, Py_LT, Py_NE)
        elif c == 0:
            return op in (Py_LE, Py_EQ, Py_GE)
        else:
            return op in (Py_GE, Py_GT, Py_NE)

    def __add__(self, other):
        cdef Integer ans = Integer.__new__(Integer)
        if type(self) is type(other):
            ans.pm_obj = (<Integer>self).pm_obj + (<Integer>other).pm_obj
        elif isinstance(self, int):
            ans.pm_obj = (<Integer>other).pm_obj + <long>self
        elif isinstance(other, int):
            ans.pm_obj = (<Integer>self).pm_obj + <long>other
        else:
            return NotImplemented
        return ans

    def __sub__(self, other):
        cdef Integer ans = Integer.__new__(Integer)
        if type(self) is type(other):
            ans.pm_obj = (<Integer>self).pm_obj - (<Integer>other).pm_obj
        elif isinstance(self, int):
            ans.pm_obj = -((<Integer>other).pm_obj - <long>self)
        elif isinstance(other, int):
            ans.pm_obj = (<Integer>self).pm_obj - <long>other
        else:
            return NotImplemented
        return ans

    def __mul__(self, other):
        cdef Integer ans = Integer.__new__(Integer)
        if type(self) is type(other):
            ans.pm_obj = (<Integer>self).pm_obj * (<Integer>other).pm_obj
        elif isinstance(self, int):
            ans.pm_obj = (<Integer>other).pm_obj * <long>self
        elif isinstance(other, int):
            ans.pm_obj = (<Integer>self).pm_obj * <long>other
        else:
            return NotImplemented
        return ans

    def __div__(self, other):
        if not other:
            raise ZeroDivisionError("polymake.number.Integer division by zero")

        cdef Integer ans = Integer.__new__(Integer)
        if type(self) is type(other):
            ans.pm_obj = (<Integer>self).pm_obj / (<Integer>other).pm_obj
        elif isinstance(self, int):
            ans.pm_obj = (<Integer>Integer(self)).pm_obj / (<Integer>other).pm_obj
        elif isinstance(other, int):
            ans.pm_obj = (<Integer>self).pm_obj / <long>other
        else:
            return NotImplemented
        return ans

    def sage(self):
        r"""Converts to a Sage integer

        >>> import polymake
        >>> a = polymake.Integer(2)
        >>> a.sage()
        2
        >>> type(a.sage())
        """
        from .sage_conversion import Integer_to_sage
        return Integer_to_sage(self)

cdef class Rational:
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

    def __div__(self, other):
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


