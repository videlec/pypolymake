###############################################################################
#       Copyright (C) 2011-2012 Burcin Erocal <burcin@erocal.org>
#                     2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################


from .defs cimport (pm_AnyString, pm_AnyString_from_string, call_function, call_function1, call_function2, call_function3,
        new_PerlObject_from_PerlObject)


from .properties cimport (handlers, pm_type_unknown, type_properties,
        pm_type_polytope_rational)

cdef int DEBUG = 0

# this is a bug in Cython!
def _NOT_TO_BE_USED_():
    raise ValueError

cdef PerlObject wrap_perl_object(pm_PerlObject pm_obj):
    cdef PerlObject ans = PerlObject.__new__(PerlObject)
    ans.pm_obj = new_PerlObject_from_PerlObject(pm_obj)
    pm_type = pm_obj.type().name()
    ans.properties = type_properties.get(pm_type)
    if ans.properties is None:
        for k,v in type_properties.items():
            if pm_type.startswith(k):
                ans.properties = v
    return ans

def call_polymake_function(app, str name, *args):
    cdef pm_AnyString * pm_name = new pm_AnyString(name)
    pm.set_application(app)
    cdef pm_PerlObject pm_obj
    if len(args) == 0:
        pm_obj = call_function(pm_name[0])
    elif len(args) == 1:
        pm_obj = call_function1(pm_name[0], args[0])
    elif len(args) == 2:
        pm_obj = call_function2(pm_name[0], args[0], args[1])
    elif len(args) == 3:
        pm_obj = call_function3(pm_name[0], args[0], args[1], args[2])
    else:
        raise NotImplementedError("can only handle 0-3 arguments")

    return wrap_perl_object(pm_obj)

cdef class PerlObject:
    def __dealloc__(self):
        del self.pm_obj

    def __getattr__(self, name):
        if DEBUG:
            print("__getattr__:\n  self = {}\n  name = {}".format(type(self), name))
        try:
            pm_type = self.properties[name]
        except KeyError:
            if DEBUG:
                print("  unregistered property...")
            handler = handlers[pm_type_unknown]
        else:
            if DEBUG:
                print("  pm_type = {}".format(pm_type))
            handler = handlers[pm_type]
        return handler(self, name)

    def __dir__(self):
        if self.properties is None:
            return dir(self.__class__)
        else:
            return dir(self.__class__) + self.properties.keys()

    def _save(self, filename):
        """
        Saves this polytope to a file using polymake's representation.
        """
        self.pm_obj.save(filename)

    def _get_property(self, prop, pm_type=None):
        r"""
        Generic method to get a property of the object

        >>> import polymake
        >>> p = polymake.cube(3)
        >>> g = p._get_property('GRAPH')
        >>> g
        Graph<Undirected> as Polytope::Lattice::GRAPH<...>
        >>> g._get_integer_property('N_NODES')
        8
        >>> g._get_integer_property('N_EDGES')
        12
        """
        if pm_type is None:
            pm_type = pm_type_unknown
        return handlers[pm_type](self, prop)

    def type_name(self):
        r"""
        Return the name of the type of this object
        """
        return <bytes> self.pm_obj.type().name()

    def name(self):
        return <bytes> self.pm_obj.name()

    def description(self):
        r"""
        .. WARNING::

            Sometimes this gives a Segmentation fault!
        """
        return <bytes> self.pm_obj.description()

    def __str__(self):
        return "{}<{}>".format(self.type_name(), hex(id(self)))

    def __repr__(self):
        return "{}<{}>".format(self.type_name(), hex(id(self)))

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
        if self.type_name() == pm_type_polytope_rational:
            from sage.geometry.polyhedron.constructor import Polyhedron
            return Polyhedron(ieqs=self.FACETS.sage(), eqns=self.AFFINE_HULL.sage())

        raise NotImplementedError("Sage conversion not implemented for {}".format(self.type_name()))

