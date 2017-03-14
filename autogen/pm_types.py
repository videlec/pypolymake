atomic_types = {
    "Bool":
    {
        "name"  : "Bool",
        "simple": True,
        "module": None,
        "perl"  : "Bool",
        "cpp"   : "bool",
        "cython": "bool"
    },

    "Int":
    {
        "name"   : "Int",
        "simple" : True,
        "module" : None,
        "perl"   : "Int",
        "cpp"    : "int",
        "cython" : "int"
    },

    "Float":
    {
        "name"   : "Float",
        "simple" : True,
        "module" : None,
        "perl"   : "Float",
        "cpp"    : "float",
        "cython" : "float"
    },


    "String":
    {
        "name"   : "String",
        "simple" : True,
        "module" : None,
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

    "QuadraticExtensionRational":
    {
        "name"   : "QuadraticExtensionRational",
        "simple" : False,
        "module" : "QuadraticExtension",
        "perl"   : "QuadraticExtension<Rational>",
        "cpp"    : "QuadraticExtension<Rational>",
        "cython" : "QuadraticExtensionRational"
    },

    "PairStringString":
    {
        "name"   : "PairStringString",
        "simple" : False,
        "module" : None,
        "perl"   : "Pair<String, String>",
        "cpp"    : "std::pair<std::string, std::string>",
        "cython" : "PairStringString"
    },

    "PairStringArrayString":
    {
        "name"   : "PairStringArrayString",
        "simple" : False,
        "module" : None,
        "perl"   : "Pair<String, Array<String>>",
        "cpp"    : "std::pair<std::string, Array<std::string>>",
        "cython" : "PairStringArrayString"
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
        "Rational",
        "QuadraticExtensionRational",
    ],

    "SparseMatrix":
    [
        ("Int", "NonSymmetric"),
        ("Rational", "NonSymmetric")
    ],

# polynomials, rational functions

    "Polynomial":
    [
        ("Rational", "Int")
    ],

    "RationalFunction":
    [
        ("Rational", "Int")
    ],

# containers
    "Array":
    [
        "Bool",
        "Int",
        "Rational",
        "String",
        "ArrayInt",
        "ArrayString",
        "SetInt",
        "PairStringString",
        "MatrixInteger",
        "ArrayPairStringString",
        "PairStringArrayString",
        "PowerSetInt",
        "SetArrayInt"
    ],

    "Set":
    [
        "Int",
        "SetInt",
        "MatrixRational",
        "ArrayInt"
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
        perl = "Matrix<{scal}, NonSymmetric>".format(scal=atomic_types[scal]["perl"])
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
        perl = "SparseMatrix<{scal}, {sym}>".format(scal=atomic_types[scal]["perl"], sym=sym)
        cpp = "SparseMatrix<{scal}, {sym}>".format(scal=atomic_types[scal]["cpp"], sym=sym)

        ans[cython] = {
            "name"  : cython,
            "simple": False,
            "module": "SparseMatrix",
            "cython": cython,
            "perl"  : perl,
            "cpp"   : cpp}

    for (coeff, exp) in module_data["Polynomial"]:
        cython = "UniPolynomial{coeff}{exp}".format(coeff=coeff, exp=exp)
        perl = "UniPolynomial<{coeff}, {exp}>".format(coeff=coeff, exp=exp)
        cpp = "UniPolynomial<{coeff}, {exp}>".format(coeff=atomic_types[coeff]["cpp"],
                                                     exp=atomic_types[exp]["cpp"])

        ans[cython] = {
            "name"  : cython,
            "simple": False,
            "module": "Polynomial",
            "cython": cython,
            "perl"  : perl,
            "cpp"   : cpp}

    for (coeff, exp) in module_data["RationalFunction"]:
        cython = "RationalFunction{coeff}{exp}".format(coeff=coeff, exp=exp)
        perl = "RationalFunction<{coeff}, {exp}>".format(coeff=coeff, exp=exp)
        cpp = "RationalFunction<{coeff}, {exp}>".format(coeff=atomic_types[coeff]["cpp"],
                                                        exp=atomic_types[exp]["cpp"])

        ans[cython] = {
            "name"  : cython,
            "simple": False,
            "module": "RationalFunction",
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

def pm_modules():
    ans = set(typ["module"] for typ in pm_types().values())
    ans.remove(None)
    return sorted(caml_to_python(x) for x in ans)
