atomic_types = {
    "Bool":
    {
        "simple" : True,
        "module" : "none",
        "perl"   : "Bool",
        "cpp"    : "bool",
        "cython" : "bool"
    },

    "Int":
    {
        "simple": True,
        "module": "none",
        "perl"  : "Int",
        "cpp"   : "int",
        "cython": "int"
    },

    "Float":
    {
        "simple": True,
        "module": "none",
        "perl"  : "Float",
        "cpp"   : "float",
        "cython": "float"
    },


    "String":
    {
        "simple" : True,
        "module" : "none",
        "perl"   : "String",
        "cpp"    : "std::string",
        "cython" : "string"
    },

    "Integer":
    {
        "simple" : False,
        "module" : "integer",
        "perl"   : "Integer",
        "cpp"    : "Integer",
        "cython" : "Integer"
    },

    "Rational":
    {
        "simple" : False,
        "module" : "rational",
        "perl"   : "Rational",
        "cpp"    : "Rational",
        "cython" : "Rational"
    },

    "PairStringString":
    {
        "simple" : False,
        "module" : "extra_types",
        "perl"   : "Pair<String, String>",
        "cpp"    : "std::pair<std::string, std::string>",
        "cython" : "PairStringString"
    }
}


module_data = {
# unique types
    "Integer":  None,
    "Rational": None,
    "IncidenceMatrix": None,

# vectors and matrices
    "Vector":
    [
        "Integer",
        "Rational"
    ],

    "Matrix":
    [
        "Int",
        "Float",
        "Integer",
        "Rational"
    ],

    "SparseMatrix":
    [
        ("Int", "NonSymmetric"),
        ("Rational", "NonSymmetric")
    ],

# containers
    "Array":
    [
        "Bool",
        "Int",
        "Rational",
        "String",
        "ArrayInt",
        "SetInt",
        "PairStringString",
        "MatrixInteger",
        "ArrayPairStringString"
    ],

    "Set":
    [
        "Int",
        "SetInt",
        "MatrixRational"
    ],

# maps
    "Map":
    [
        ("String", "String"),
        ("Rational", "Rational"),
        ("Int", "Int"),
        ("Integer", "Int")
    ],
}


def pm_types():
    r"""
    The list of supported polymake types.

    OUTPUT:

    A dictionary:
      name -> dictionary of properties
    """
    ans = atomic_types.copy()

    for scal in module_data["Vector"]:
        cython = "Vector{scal}".format(scal=scal)
        perl = "Vector<{scal}>".format(scal=scal)
        cpp = "Vector<{scal}>".format(scal=atomic_types[scal]["cpp"])

        ans[cython] = {
            "simple": False,
            "module": "vector",
            "cython": cython,
            "perl"  : perl,
            "cpp"   : cpp}

    for scal in module_data["Matrix"]:
        cython = "Matrix{scal}".format(scal=scal)
        perl = "Matrix<{scal}, NonSymmetric>".format(scal=scal)
        cpp = "Matrix<{scal}>".format(scal=atomic_types[scal]["cpp"])

        ans[cython] = {
            "simple": False,
            "module": "matrix",
            "cython": cython,
            "perl"  : perl,
            "cpp"   : cpp}

    for (scal, sym) in module_data["SparseMatrix"]:
        cython = "SparseMatrix{scal}{sym}".format(scal=scal, sym=sym)
        perl = "SparseMatrix<{scal}, {sym}>".format(scal=scal, sym=sym)
        cpp = "SparseMatrix<{scal}, {sym}>".format(scal=atomic_types[scal]["cpp"], sym=sym)

        ans[cython] = {
            "simple": False,
            "module": "sparse_matrix",
            "cython": cython,
            "perl"  : perl,
            "cpp"   : cpp}

    ans["IncidenceMatrixNonSymmetric"] = {
        "simple": False,
        "module": "incidence_matrix",
        "cython": "IncidenceMatrixNonSymmetric",
        "perl"  : "IncidenceMatrix<NonSymmetric>",
        "cpp"   : "IncidenceMatrix<NonSymmetric>"
        }


    # containers
    todo = set((c,s) for c in ("Array","Set") for s in module_data[c])
    while todo:
        print(todo)
        todo2 = set()
        while todo:
            c, s = todo.pop()
            if s not in ans:
                todo2.add((c,s))
                continue
            
            data = ans[s]
            cython = "{container}{subtype}".format(container=c, subtype=s)
            perl = "{container}<{subtype}>".format(container=c, subtype=data["perl"])
            cpp = "{container}<{subtype}>".format(container=c, subtype=data["cpp"])

            ans[cython] = {
                "simple": False,
                "module": c.lower(),
                "cython": cython,
                "perl"  : perl,
                "cpp"   : cpp}

        todo = todo2

    return ans
