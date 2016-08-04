###############################################################################
#       Copyright (C) 2011-2012 Burcin Erocal <burcin@erocal.org>
#                     2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################


from .properties cimport handlers, property_unknown
cdef int DEBUG = 0

# this is a bug in Cython!
def _NOT_TO_BE_USED_():
    raise ValueError

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
            handler = handlers[property_unknown]
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
            pm_type = property_unknown
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

    def __repr__(self):
        return "{}<{}>".format(self.type_name(), hex(id(self)))


