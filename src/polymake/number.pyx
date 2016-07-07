# distutils: language = c++
# distutils: libraries = polymake gmp xml2 perl

###############################################################################
#       Copyright (C) 2016 Vincent Delecroix <vincent.delecroix@labri.fr> 
#
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 2 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from cpython.object cimport Py_LT, Py_LE, Py_EQ, Py_NE, Py_GT, Py_GE
from operator import add as op_add, mul as op_mul, sub as op_sub, div as op_div, pow as op_pow

from cygmp.types cimport mpz_t, mpq_t
from cygmp.mpz cimport mpz_init, mpz_clear, mpz_set_si, mpz_add, mpz_sub, mpz_mul, mpz_cmp
from cygmp.utils cimport mpz_set_pylong, mpz_get_bytes, mpq_get_bytes

cpdef Integer Integer_binop(Integer a, Integer b, op): 
    cdef Integer ans = Integer.__new__(Integer)
    cdef mpz_t z
    mpz_init(z)

    if op is op_add:
        mpz_add(z, a.pm_obj.get_rep(), b.pm_obj.get_rep())
    elif op is op_sub:
        mpz_sub(z, a.pm_obj.get_rep(), b.pm_obj.get_rep())
    elif op is op_mul:
        mpz_mul(z, a.pm_obj.get_rep(), b.pm_obj.get_rep())
    elif op is op_pow:
        raise NotImplementedError
    else:
        raise TypeError("{!r} is not a valid operator".format(op))

    ans.pm_obj.set(z)
    mpz_clear(z)
    return ans

cdef class Integer:
    r"""
    Polymake integer
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

    def __repr__(self):
        return mpz_get_bytes(self.pm_obj.get_rep())

    def __int__(self):
        return self.pm_obj.to_long()

    def __float__(self):
        return self.pm_obj.to_double()

    def __richcmp__(self, other, op):
        if type(self) is not type(other):
            raise TypeError
        cdef int c = mpz_cmp((<Integer>self).pm_obj.get_rep(),
                        (<Integer>other).pm_obj.get_rep())
        if c < 0:
            return op in (Py_LE, Py_LT, Py_NE)
        elif c == 0:
            return op in (Py_LE, Py_EQ, Py_GE)
        else:
            return op in (Py_GE, Py_GT, Py_NE)

    def __add__(self, other):
        if type(self) is not type(other):
            raise TypeError
        return Integer_binop(self, other, op_add)

    def __sub__(self, other):
        if type(self) is not type(other):
            raise TypeError
        return Integer_binop(self, other, op_sub)

    def __mul__(self, other):
        if type(self) is not type(other):
            raise TypeError
        return Integer_binop(self, other, op_mul)

#    def __dealloc__(self):
#        del self.pm_obj

cdef class Rational:
    r"""
    Polymake rational
    """
    def __repr__(self):
        return mpq_get_bytes(self.pm_obj.get_rep())
