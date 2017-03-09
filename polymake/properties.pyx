# distutils: language = c++
# distutils: libraries = gmp polymake
r"""
Handlers for polymake objects

This file organizes the conversion of C++ polymake objects
to the actual wrappers of the pypolymake library. Most of the code
is actually generated automatically at build time in "handlers.pxi"
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

from .perl_object cimport pm

from .defs cimport *
from .perl_object cimport *

from .array cimport *
from .map cimport *
from .matrix cimport *
from .number cimport *
from .vector cimport *


cdef extern from "wrap.h" namespace "polymake":
    void pm_get_PerlObject "GIVE" (pm_PerlObject, pm_PerlObject*, string)

    void pm_get1_int "GIVE" (int, pm_PerlObject*, string) except +
    void pm_get2_int "CALL_METHOD" (int, pm_PerlObject*, string) except +

    void pm_get1_float "GIVE" (float, pm_PerlObject*, string) except +
    void pm_get2_float "CALL_METHOD" (float, pm_PerlObject*, string) except +


def handler_generic(PerlObject perl_object, bytes prop):
    cdef pm_PerlObject pm_ans
    print("  pypolymake debug WARNING: generic handler")
    pm_get_PerlObject(pm_ans, perl_object.pm_obj, prop)
    if not pm_ans.valid():
        raise ValueError("invalid property {}".format(prop))

    return wrap_perl_object(pm_ans)

def handler_bool(PerlObject perl_object, bytes prop):
    return handler_int(perl_object, prop)

def handler_int(PerlObject perl_object, bytes prop):
    cdef int ans
    try:
        pm_get1_int(ans, perl_object.pm_obj, prop)
    except RuntimeError:
        pm_get2_int(ans, perl_object.pm_obj, prop)
    return ans

def handler_float(PerlObject perl_object, bytes prop):
    cdef float ans
    try:
        pm_get1_float(ans, perl_object.pm_obj, prop)
    except RuntimeError:
        pm_get2_float(ans, perl_object.pm_obj, prop)
    return ans

include "handlers.pxi"

cdef dict handlers = {
    b"Bool"          : handler_bool,
    b"Int"           : handler_int,
    b"Float"         : handler_float,
}
include "auto_mappings.pxi"
handlers.update(auto_handlers)

cdef list small_types = [b"Array", b"Integer", b"Map", b"Matrix", b"PowerSet",
        b"Rational", b"Set", b"SparseMatrix", b"SparseVector", b"Vector"]

cpdef get_handler(bytes pm_type):
    cdef bytes typ
    global handlers
    try:
        return handlers[pm_type]
    except KeyError:
        for typ in small_types:
            if pm_type.startswith(typ):
                raise NotImplementedError("lacking support for polymake small type {}".format(pm_type))
        print("  pypolymake debug WARNING: falling back to generic handler")
        return handler_generic
