# distutils: language = c++
# distutils: libraries = polymake
###############################################################################
#       Copyright (C) 2011-2012 Burcin Erocal <burcin@erocal.org>
#                     2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from libcpp.string cimport string

from .defs cimport (call_function, call_function1, call_function2, call_function3,
        new_PerlObject_from_PerlObject, pm_PerlObject, pm_MapStringString)
from .map cimport MapStringString
from .main cimport pm


from .handlers cimport get_property_handler, get_method_handler

cdef int DEBUG = 0


# this is a bug in Cython!
def _NOT_TO_BE_USED_():
    raise ValueError

cdef extern from "polymake/client.h" namespace "polymake":
    pm_MapStringString call_it "call_function" (string, pm_PerlObject) except +

cpdef dict get_properties(PerlObject p):
    r"""
    Return the dictionary of properties of the perl object ``p``

    The argument must correspond to a "big object" in polymake. The result
    is a dictionary where keys are attributes and keys are types.

    EXAMPLES:

    >>> import polymake
    >>> from polymake.properties import get_properties
    >>> c = polymake.cube(3)
    >>> m = get_properties(c)
    """
    pm.pm_include("common::sage.rules")
    cdef MapStringString s = MapStringString.__new__(MapStringString)
    s.pm_obj = call_it(<string> "Sage::properties_for_object", p.pm_obj[0])
    return s.python()

cpdef dict get_methods(PerlObject p):
    r"""
    Return the dictionary of methods of the perl object ``p``

    EXAMPLES:

    >>> import polymake
    >>> from polymake.properties import get_methods
    >>> c = polymake.cube(3)
    >>> m = get_methods(c)
    """
    pm.pm_include("common::sage.rules")
    cdef MapStringString s = MapStringString.__new__(MapStringString)
    s.pm_obj = call_it(<string> "Sage::methods_for_object", p.pm_obj[0])
    return s.python()

# Hand written handler that
cdef PerlObject wrap_perl_object(pm_PerlObject pm_obj):
    cdef PerlObject ans = PerlObject.__new__(PerlObject)
    ans.pm_obj = new_PerlObject_from_PerlObject(pm_obj)
    ans.properties = get_properties(ans)
    ans.methods = get_methods(ans)
    return ans

def call_polymake_function(bytes app, bytes name, *args):
    from .main import pm_set_application
    pm_set_application(app)
    cdef pm_PerlObject pm_obj
    if len(args) == 0:
        pm_obj = call_function(name)
    elif len(args) == 1:
        pm_obj = call_function1(name, args[0])
    elif len(args) == 2:
        pm_obj = call_function2(name, args[0], args[1])
    elif len(args) == 3:
        pm_obj = call_function3(name, args[0], args[1], args[2])
    else:
        raise NotImplementedError("can only handle 0-3 arguments")

    return wrap_perl_object(pm_obj)

cdef class PerlObject:
    def __dealloc__(self):
        del self.pm_obj

    def __getattr__(self, name):
        cdef bytes bname = name.encode('utf-8')
        if DEBUG:
            print("  pypolymake debug WARNING: __getattr__:\n  self = {}\n  name = {}".format(type(self), bname))

        if bname in self.properties:
            pm_type = self.properties[bname]
            handler = get_property_handler(pm_type)

        elif bname in self.methods:
            pm_type = self.methods[bname]
            if not pm_type:
                raise ValueError("polymake documentation is incomplete: type of {}->{} not available. Send a request to polymake developers!".format(self, name))
            handler = get_method_handler(pm_type)

        else:
            raise AttributeError("{} not a registered attribute".format(name))

        return handler(self, bname)

    def __dir__(self):
        return dir(self.__class__) + [x.decode('ascii') for x in self.properties] + [x.decode('ascii') for x in self.methods]

    def _save(self, filename):
        """
        Saves this polytope to a file using polymake's representation.
        """
        self.pm_obj.save(filename)

    def type_name(self):
        r"""
        Return the name of the type of this object
        """
        return (<bytes> self.pm_obj.type().name()).decode('ascii')

    def __str__(self): return self.type_name()
    def __repr__(self): return self.type_name()

    def name(self):
        return (<bytes> self.pm_obj.name()).decode('ascii')

    def sage(self):
        r"""Converts to a Sage object

        >>> import polymake
        >>> P = polymake.Polytope("POINTS", [(1,1,0),(1,2,1)])
        >>> Q = P.sage()
        >>> Q.vertices_list()
        [[2, 1], [1, 0]]
        >>> P = polymake.Polytope("FACETS", [(0,1,0),(1,-1,0),(0,0,1)])
        >>> P.sage()
        A 2-dimensional polyhedron in QQ^2 defined as the convex hull of 2 vertices and 1 ray
        """
        if self.type_name() == b"Polytope<Rational>":
            from sage.geometry.polyhedron.constructor import Polyhedron
            return Polyhedron(ieqs=self.FACETS.sage(), eqns=self.AFFINE_HULL.sage())

        raise NotImplementedError("Sage conversion not implemented for {}".format(self.type_name()))

