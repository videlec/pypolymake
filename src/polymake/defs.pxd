# distutils: language = c++

from libcpp cimport bool
from libcpp.string cimport string
from cygmp.types cimport mpz_t, mpq_t, mpz_srcptr

cdef extern from "wrap.h" namespace "polymake":
    pass

cdef extern from "polymake/Main.h" namespace "polymake":
    cdef cppclass Main:
        void set_application(char*)
        void set_preference(char*)

    cdef cppclass PropertyValue:
        pass

cdef extern from "polymake/Rational.h" namespace 'polymake':
    ctypedef pm_const_Integer "const Integer"
    cdef cppclass pm_Integer "Integer" :
        mpz_t get_rep()
        Py_ssize_t strsize(int)
        int compare(int)
        long to_long()   # FIXME: this is const
        double to_double()
        pm_Integer& set(mpz_srcptr)

    ctypedef pm_const_Rational "const Rational"
    cdef cppclass pm_Rational "Rational":
#        pm_Rational(mpq_t)
        mpq_t get_rep()
        pm_Rational set_mpq_t "set" (mpq_t)
        pm_Rational& set_mpq_srcptr "set" (mpq_srcptr)
#        pm_Rational operator+ (pm_const_Rational&)

#ctypedef const_string "const std::string"

cdef extern from "polymake/client.h":
    cdef cppclass pm_PerlObject "perl::Object":
        pm_PerlObject()
        pm_PerlObject(char*) except +ValueError
        void VoidCallPolymakeMethod(char*) except +ValueError
        void save(char*)
        PropertyValue take(char*)
        PropertyValue give(char*) # do not add except here, see pm_get for why
#        int exists(const_string& name)

    pm_PerlObject CallPolymakeFunction (char*) except +ValueError
    pm_PerlObject CallPolymakeFunction1 "CallPolymakeFunction" \
            (char*, int) except +ValueError
    pm_PerlObject CallPolymakeFunction2 "CallPolymakeFunction" \
            (char*, int, int) except +ValueError
    pm_PerlObject CallPolymakeFunction3 "CallPolymakeFunction" \
            (char*, int, int, int) except +ValueError
    pm_PerlObject* new_PerlObject_from_PerlObject "new perl::Object" (pm_PerlObject)


cdef extern from "polymake/Matrix.h" namespace 'polymake':
    cdef cppclass pm_MatrixRational "Matrix<Rational>":
        pm_MatrixRational()
        pm_MatrixRational(int nr, int nc)
        void assign(int r, int c, pm_Rational val)
        pm_MatrixRational operator|(pm_MatrixRational)
        Py_ssize_t rows()
        Py_ssize_t cols()

    # WRAP_CALL(t,i,j) -> t(i,j)
    pm_Rational get_element "WRAP_CALL"(pm_MatrixRational, int i, int j)

#cdef extern from "polymake/GenericVector.h" namespace 'polymake':
    pm_MatrixRational ones_vector_Rational "ones_vector<Rational>" ()

#cdef extern from "polymake/GenericMatrix.h" namespace 'polymake':
    pm_MatrixRational unit_matrix_Rational "unit_matrix<Rational>" (int dim)


    # WRAP_OUT(x,y) x<<y
    void pm_assign_MatrixRational "WRAP_OUT" (PropertyValue, pm_MatrixRational)

    # the except clause below is fake
    # it is used to catch errors in PerlObject.give(), however adding
    # the except statement to the declaration of give() makes cython
    # split lines like
    #        pm_get(self.pm_obj.give(prop), pm_res)
    # and store the result of give() first. This causes problems since
    # PropertyValue doesn't have a default constructor.

    # WRAP_IN(x,y) x>>y
    void pm_get_Integer "WRAP_IN" (PropertyValue, pm_Integer) except +ValueError
    void pm_get_MatrixRational "WRAP_IN" (PropertyValue, pm_MatrixRational) except +ValueError
    void pm_get_VectorInteger "WRAP_IN" (PropertyValue, pm_VectorInteger) except +ValueError
    void pm_get_PerlObject "WRAP_IN" (PropertyValue, pm_PerlObject) except +ValueError

cdef extern from "polymake/Vector.h" namespace 'polymake':
    cdef cppclass pm_VectorInteger "Vector<Integer>":
        pm_VectorInteger()
        pm_VectorInteger(int nr)
        #void assign(int r, int val)
        pm_Integer get "operator[]" (int i)
        int size()

    cdef cppclass pm_VectorRational "Vector<Rational>":
        pm_VectorRational()
        pm_VectorRational(int nr)
        pm_Rational get "operator []" (int i)
        int size()


#cdef extern from "utils.h":
#    string Integer_repr(pm_Integer &);
