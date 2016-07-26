###############################################################################
#       Copyright (C) 2016 Vincent Delecroix <vincent.delecroix@labri.fr> 
#
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from cpython.object cimport Py_LT, Py_LE, Py_EQ, Py_NE, Py_GT, Py_GE
from operator import add as op_add,\
                     mul as op_mul,\
                     sub as op_sub,\
                     div as op_div,\
                     pow as op_pow

from cygmp.types cimport mpz_t, mpq_t
from cygmp.mpz cimport mpz_init, mpz_clear, mpz_set_si, mpz_sgn
from cygmp.mpq cimport mpq_init, mpq_clear, mpq_numref, mpq_denref, mpq_canonicalize
from cygmp.utils cimport mpz_set_pylong, mpz_get_bytes, mpq_get_bytes

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
    if isinstance(num, (int,long)) and isinstance(den, (int,long)):
        return (num, den)

    raise ValueError("not able to convert {} to a rational".format(elt))


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

        self.pm_obj.set(z)
        mpz_clear(z)

    def __nonzero__(self):
        return mpz_sgn(self.pm_obj.get_rep()) != 0

    def __repr__(self):
        return mpz_get_bytes(self.pm_obj.get_rep())

    def __int__(self):
        return self.pm_obj.to_long()

    def __float__(self):
        return self.pm_obj.to_double()

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

cdef class Rational:
    r"""Polymake rational
    """
    def __init__(self, num, den=None):
        if den is None:
            num, den = get_num_den(num)

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
        self.pm_obj.set_mpq_t(z)
        mpq_clear(z)

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
        return mpq_get_bytes(self.pm_obj.get_rep())

    def __add__(self, other):
        cdef Rational ans = Rational.__new__(Rational)
        if type(self) is type(other):
            ans.pm_obj = (<Rational>self).pm_obj + (<Rational>other).pm_obj
        elif type(self) is Integer:
            ans.pm_obj = (<Rational>other).pm_obj + (<Integer>other).pm_obj
        elif type(other) is Integer:
            ans.pm_obj = (<Rational>self).pm_obj + (<Integer>other).pm_obj
        elif isinstance(self, long):
            ans.pm_obj = (<Rational>other).pm_obj + <long>self
        elif isinstance(other, long):
            ans.pm_obj = (<Rational>self).pm_obj + <long>other
        else:
            return NotImplemented
        return ans

    def __sub__(self, other):
        cdef Rational ans = Rational.__new__(Rational)
        if type(self) is type(other):
            ans.pm_obj = (<Rational>self).pm_obj - (<Rational>other).pm_obj
        elif type(self) is Integer:
            ans.pm_obj = (<Rational>other).pm_obj - (<Integer>other).pm_obj
        elif type(other) is Integer:
            ans.pm_obj = (<Rational>self).pm_obj - (<Integer>other).pm_obj
        elif isinstance(self, long):
            ans.pm_obj = (<Rational>other).pm_obj - <long>self
        elif isinstance(other, long):
            ans.pm_obj = (<Rational>self).pm_obj - <long>other
        else:
            return NotImplemented
        return ans

    def __mul__(self, other):
        cdef Rational ans = Rational.__new__(Rational)
        if type(self) is type(other):
            ans.pm_obj = (<Rational>self).pm_obj * (<Rational>other).pm_obj
        elif type(self) is Integer:
            ans.pm_obj = (<Rational>other).pm_obj * (<Integer>other).pm_obj
        elif type(other) is Integer:
            ans.pm_obj = (<Rational>self).pm_obj * (<Integer>other).pm_obj
        elif isinstance(self, long):
            ans.pm_obj = (<Rational>other).pm_obj * <long>self
        elif isinstance(other, long):
            ans.pm_obj = (<Rational>self).pm_obj * <long>other
        else:
            return NotImplemented
        return ans

    def __div__(self, other):
        cdef Rational ans = Rational.__new__(Rational)
        if type(self) is type(other):
            ans.pm_obj = (<Rational>self).pm_obj / (<Rational>other).pm_obj
        elif type(other) is Integer:
            ans.pm_obj = (<Rational>self).pm_obj / (<Integer>other).pm_obj
        elif isinstance(other, long):
            ans.pm_obj = (<Rational>self).pm_obj / <long>other
        else:
            if not type(self) is Rational:
                try:
                    return Rational(self) / <Rational>other
                except (ValueError,TypeError):
                    pass
            return NotImplemented
        return ans
