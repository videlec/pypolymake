# distutils: language = c++
# distutils: libraries = polymake
r"""
Handlers for polymake objects

This file organizes the conversion of C++ polymake objects
to the actual wrappers of the pypolymake library. Most of the code
is actually generated automatically at build time in "auto_handlers.pxi"
and "auto_mappings.pxi".
"""
###############################################################################
#       Copyright (C) 2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from libcpp cimport bool
from libcpp.string cimport string

from .defs cimport *
from .perl_object cimport *

from .array cimport *
from .map cimport *
from .matrix cimport *
from .number cimport *
from .vector cimport *


cdef extern from "wrap.h" namespace "polymake":
    void pm_give_PerlObject "GIVE" (pm_PerlObject, pm_PerlObject*, string)
    void pm_call_method_PerlObject "CALL_METHOD" (pm_PerlObject, pm_PerlObject*, string)

    void pm_give_int "GIVE" (int, pm_PerlObject*, string) except +
    void pm_call_method_int "CALL_METHOD" (int, pm_PerlObject*, string) except +

    void pm_give_float "GIVE" (float, pm_PerlObject*, string) except +
    void pm_call_method_float "CALL_METHOD" (float, pm_PerlObject*, string) except +


def give_generic(PerlObject perl_object, bytes prop):
    cdef pm_PerlObject pm_ans
    pm_give_PerlObject(pm_ans, perl_object.pm_obj, prop)
    if not pm_ans.valid():
        raise ValueError("invalid property {}".format(prop))
    return wrap_perl_object(pm_ans)

def call_method_generic(PerlObject perl_object, bytes prop):
    cdef pm_PerlObject pm_ans
    pm_call_method_PerlObject(pm_ans, perl_object.pm_obj, prop)
    if not pm_ans.valid():
        raise ValueError("invalid property {}".format(prop))
    return wrap_perl_object(pm_ans)

def give_bool(PerlObject perl_object, bytes prop):
    return give_int(perl_object, prop)

def call_method_bool(PerlObject perl_object, bytes prop):
    return call_method_int(perl_object, prop)

def give_int(PerlObject perl_object, bytes prop):
    cdef int ans
    pm_give_int(ans, perl_object.pm_obj, prop)
    return ans
def call_method_int(PerlObject perl_object, bytes prop):
    cdef int ans
    pm_call_method_int(ans, perl_object.pm_obj, prop)
    return ans

def give_float(PerlObject perl_object, bytes prop):
    cdef float ans
    pm_give_float(ans, perl_object.pm_obj, prop)
    return ans
def call_method_float(PerlObject perl_object, bytes prop):
    cdef float ans
    pm_call_method_float(ans, perl_object.pm_obj, prop)
    return ans

include "auto_handlers.pxi"

cdef dict property_handlers = {
    b"Bool"          : give_bool,
    b"Int"           : give_int,
    b"Float"         : give_float,
}
cdef dict method_handlers = {
    b"Bool"          : call_method_bool,
    b"Int"           : call_method_int,
    b"Float"         : call_method_float
}
include "auto_mappings.pxi"
property_handlers.update(auto_property_handlers)
method_handlers.update(auto_method_handlers)

cdef list small_types = [b"Array", b"Integer", b"Map", b"Matrix", b"PowerSet",
        b"Rational", b"Set", b"SparseMatrix", b"SparseVector", b"Vector"]

cpdef get_property_handler(bytes pm_type):
    global property_handlers
    try:
        return property_handlers[pm_type]
    except KeyError:
        raise NotImplementedError("pypolymake does not handle {} polymake type".format(pm_type))

cpdef get_method_handler(bytes pm_type):
    global method_handlers
    try:
        return method_handlers[pm_type]
    except KeyError:
        raise NotImplementedError("pypolymake does not handle {} polymake type".format(pm_type))

