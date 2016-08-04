from perl_object import call_polymake_function

def associahedron(d):
    r"""Produce a d-dimensional associahedron (or Stasheff polytope)

    >>> import polymake
    >>> a = polymake.associahedron(3)
    >>> a.N_VERTICES
    14
    """
    return call_polymake_function("polytope", "associahedron", d)

def birkhoff(n, even=False):
    """Constructs the Birkhoff polytope of dimension `n^2`.

    It is the polytope of `n \\times n` stochastic matrices (encoded as `n^2`
    row vectors), thus matrices with non-negative entries whose row and column
    entries sum up to one. Its vertices are the permutation matrices.

    Keyword arguments:

    n -- integer
    even -- boolean (default to False)

    >>> import polymake
    >>> b = polymake.birkhoff(3)
    >>> b.N_VERTICES
    6
    """
    return call_polymake_function("polytope", "birkhoff", n, even)

def cross(d):
    r"""Produce a d-dimensional cross polytope.

    Regular polytope corresponding to the Coxeter group of type B<sub>d-1</sub>
    = C<sub>d-1</sub>.
    """
    return call_polymake_function("polytope", "cross", d)

def cube(d, x_up=1, x_low=-1):
    r"""Produce a d-dimensional cube

    Regular polytope corresponding to the Coxeter group of type
    `B^{d-1} = C^{d-1}`.  The bounding hyperplanes are `x_i <= x_{up}` and
    `x_i >= x_{low}`.

    Keyword arguments:

    d -- dimension
    x_up -- upper bound in each dimension
    x_low -- lower bound in each dimension

    >>> import polymake
    >>> polymake.cube(2).VERTICES
    [ 1 -1 -1]
    [ 1 1  -1]
    [ 1 -1 1 ]
    [ 1 1  1 ]
    >>> polymake.cube(2,2,0).VERTICES
    [ 1 0 0]
    [ 1 2 0]
    [ 1 0 2]
    [ 1 2 2]
    """
    return call_polymake_function("polytope", "cube", d, x_up, x_low)

def cuboctahedron():
    r"""Create cuboctahedron.  An Archimedean solid.

    >>> import polymake
    >>> polymake.cuboctahedron().VERTICES
    [ 1 1  1  0 ]
    [ 1 1  0  1 ]
    [ 1 0  1  1 ]
    [ 1 1  0  -1]
    [ 1 0  1  -1]
    [ 1 1  -1 0 ]
    [ 1 0  -1 1 ]
    [ 1 -1 1  0 ]
    [ 1 -1 0  1 ]
    [ 1 0  -1 -1]
    [ 1 -1 0  -1]
    [ 1 -1 -1 0 ]
    """
    return call_polymake_function("polytope","cuboctahedron")

def cycle_graph(n):
    r"""Constructs a cycle graph on n nodes.
    
    >>> import polymake
    >>> g = polymake.cycle_graph(7)
    >>> g
    Graph<Undirected><...>
    >>> g.N_NODES
    7
    >>> g.N_EDGES
    7
    """
    return call_polymake_function("polytope", "cycle_graph", n)

def cyclic(d, n):
    r"""Produce a d-dimensional cyclic polytope with n points.

    Prototypical example of a neighborly polytope. Combinatorics completely
    known due to Gale's evenness criterion. Coordinates are chosen on the
    (spherical) moment curve at integer steps from start, or 0 if unspecified.
    If spherical is true the vertices lie on the sphere with center
    (1/2,0,...,0) and radius 1/2. In this case (the necessarily positive)
    parameter start defaults to 1.

    >>> import polymake
    >>> polymake.cyclic(2, 4).VERTICES
    [ 1 0 0]
    [ 1 1 1]
    [ 1 2 4]
    [ 1 3 9]
    >>> polymake.cyclic(3, 3)
    Traceback (most recent call last):
    ...
    ValueError: cyclic: d >= 2 and n > d required
    <BLANKLINE>
    """
    return call_polymake_function("polytope",'cyclic', d, n)

def cyclic_caratheodory(d, n):
    r"""Produce a d-dimensional cyclic polytope with n points.

    Prototypical example of a neighborly polytope. Combinatorics completely known
    due to Gale's evenness criterion. Coordinates are chosen on the trigonometric
    moment curve. For cyclic polytopes from other curves, see :func:`cyclic`.
    """
    return call_polymake_function("polytope", 'cyclic_caratheodory', d, n)

def delpezzo(d, scale=1):
    r"""
    Produce a d-dimensional del-Pezzo polytope

    It is the convex hull of the cross polytope together with the all-ones and
    minus all-ones vector. All coordinates are +/- scale or 0.

    Keyword arguments:

    d -- the dimension
    scale -- the absolute value of each non-zero vertex coordinate.

    >>> import polymake
    >>> polymake.delpezzo(2).VERTICES
    [ 1 1  0 ]
    [ 1 0  1 ]
    [ 1 -1 0 ]
    [ 1 0  -1]
    [ 1 1  1 ]
    [ 1 -1 -1]
    """
    return call_polymake_function("polytope", "delpezzo", d, scale)

def dodecahedron():
    r"""
    Create exact regular dodecahedron in Q(sqrt{5}).  A Platonic solid.

    >>> import polymake
    >>> dod = polymake.dodecahedron()
    >>> dod
    Polytope<QuadraticExtension<Rational>><...>
    """
    return call_polymake_function("polytope", "dodecahedron")

def dwarfed_cube(d):
    r"""Produce a d-dimensional dwarfed cube.

    Keyword arguments:

    d -- the dimension

    >>> import polymake
    >>> polymake.dwarfed_cube(2).N_VERTICES
    5
    """
    return call_polymake_function("polytope", "dwarfed_cube", d)

def icosahedron():
    r"""
    Create exact regular icosahedron in Q(sqrt{5}).  A Platonic solid.

    >>> import polymake
    >>> ico = polymake.icosahedron()
    >>> ico
    Polytope<QuadraticExtension<Rational>><...>
    """
    return call_polymake_function("polytope", "icosahedron")

def johnson_graph(n, k):
    r"""Create the Johnson graph on parameters (n,k).

    It has one node for each set in \({[n]}\choose{k}\),
    and an edge between two nodes iff the intersection of the corresponding
    subsets is of size k-1.

    >>> import polymake
    >>> g = polymake.johnson_graph(5, 3)
    >>> g
    Graph<Undirected><...>
    >>> g.N_NODES
    10
    >>> g.N_EDGES
    30
    """
    return call_polymake_function("polytope", "johnson_graph", n, k)

def kneser_graph(n, k):
    r"""Create the Kneser graph on parameters (n,k).

    It has one node for each set in \({[n]}\choose{k}\),
    and an edge between two nodes iff the corresponding subsets are
    disjoint.

    >>> import polymake
    >>> g = polymake.kneser_graph(6, 3)
    >>> g
    Graph<Undirected><...>
    >>> g.N_NODES
    20
    >>> g.N_EDGES
    10
    """
    return call_polymake_function("polytope", "kneser_graph", n, k)

def rand_sphere(dim, npoints):
    r"""Produce a d-dimensional polytope with n random vertices uniformly
    distributed on the unit sphere.

    Keyword arguments:

    d -- the dimension
    n -- the number of random vertices

    >>> import polymake
    >>> p = polymake.rand_sphere(3, 10)
    >>> p.N_VERTICES
    10
    """
    return call_polymake_function("polytope", "rand_sphere", dim, npoints)
