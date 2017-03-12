atomic_types = {
    "Bool":
    {
        "name"   : "Bool",
        "simple" : True,
        "module" : "none",
        "perl"   : "Bool",
        "cpp"    : "bool",
        "cython" : "bool"
    },

    "Int":
    {
        "name"  : "Int",
        "simple": True,
        "module": "none",
        "perl"  : "Int",
        "cpp"   : "int",
        "cython": "int"
    },

    "Float":
    {
        "name"  : "Float",
        "simple": True,
        "module": "none",
        "perl"  : "Float",
        "cpp"   : "float",
        "cython": "float"
    },


    "String":
    {
        "name"   : "String",
        "simple" : True,
        "module" : "none",
        "perl"   : "String",
        "cpp"    : "std::string",
        "cython" : "string"
    },

    "Integer":
    {
        "name"   : "Integer",
        "simple" : False,
        "module" : "Integer",
        "perl"   : "Integer",
        "cpp"    : "Integer",
        "cython" : "Integer"
    },

    "Rational":
    {
        "name"   : "Rational",
        "simple" : False,
        "module" : "Rational",
        "perl"   : "Rational",
        "cpp"    : "Rational",
        "cython" : "Rational"
    },

    "PairStringString":
    {
        "name"   : "PairStringString",
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
        "Int",
        "Float",
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

    "PowerSet":
    [
        "Int"
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


def caml_to_python(s):
    cap = [i for i,j in enumerate(s) if j.isupper()]
    cap.append(len(s))
    return '_'.join(s[cap[i]].lower() + s[cap[i]+1:cap[i+1]] for i in range(len(cap)-1))
def python_to_caml(s):
    und = [0]
    und.extend(i for i,j in enumerte(s) if j == '_')
    und.append(len(s))
    return ''.join(s[und[i+1]].upper() + s[und[i+1]+1:und[i+1]] for i in range(len(und)-1))

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
            "name"  : cython,
            "simple": False,
            "module": "Vector",
            "cython": cython,
            "perl"  : perl,
            "cpp"   : cpp}

    for scal in module_data["Matrix"]:
        cython = "Matrix{scal}".format(scal=scal)
        perl = "Matrix<{scal}, NonSymmetric>".format(scal=scal)
        cpp = "Matrix<{scal}>".format(scal=atomic_types[scal]["cpp"])

        ans[cython] = {
            "name"  : cython,
            "simple": False,
            "module": "Matrix",
            "cython": cython,
            "perl"  : perl,
            "cpp"   : cpp}

    for (scal, sym) in module_data["SparseMatrix"]:
        cython = "SparseMatrix{scal}{sym}".format(scal=scal, sym=sym)
        perl = "SparseMatrix<{scal}, {sym}>".format(scal=scal, sym=sym)
        cpp = "SparseMatrix<{scal}, {sym}>".format(scal=atomic_types[scal]["cpp"], sym=sym)

        ans[cython] = {
            "name"  : cython,
            "simple": False,
            "module": "sparse_matrix",
            "cython": cython,
            "perl"  : perl,
            "cpp"   : cpp}

    ans["IncidenceMatrixNonSymmetric"] = {
        "name"  : "IncidenceMatrixNonSymmetric",
        "simple": False,
        "module": "IncidenceMatrix",
        "cython": "IncidenceMatrixNonSymmetric",
        "perl"  : "IncidenceMatrix<NonSymmetric>",
        "cpp"   : "IncidenceMatrix<NonSymmetric>"
        }


    # containers
    todo = set((c,s) for c in ("Array","Set","PowerSet") for s in module_data[c])
    while todo:
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
                "name"  : cython,
                "simple": False,
                "module": c,
                "cython": cython,
                "perl"  : perl,
                "cpp"   : cpp}

        todo = todo2

    # maps
    for typ1,typ2 in module_data["Map"]:
        cython = "Map{typ1}{typ2}".format(typ1=typ1,typ2=typ2)
        perl = "Map<{typ1}, {typ2}>".format(typ1=ans[typ1]["perl"], typ2=ans[typ2]["perl"])
        cpp = "Map<{typ1}, {typ2}>".format(typ1=ans[typ1]["cpp"], typ2=ans[typ2]["cpp"])

        ans[cython] = {
            "name"  : cython,
            "simple": False,
            "module": "Map",
            "cython": cython,
            "perl"  : perl,
            "cpp"   : cpp}

    return ans
