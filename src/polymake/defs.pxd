###############################################################################
#       Copyright (C) 2011-2012 Burcin Erocal <burcin@erocal.org>
#                     2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from libcpp cimport bool
from libcpp.string cimport string
from cygmp.types cimport mpz_t, mpq_t, mpz_srcptr, mpq_srcptr

cdef extern from "wrap.h" namespace "polymake":
    pass

# new in beta
cdef extern from "polymake/AnyString.h" namespace "polymake":
    cdef cppclass pm_AnyString "AnyString":
        pm_AnyString()
        pm_AnyString(string)
        pm_AnyString(char *, size_t)

    cdef pm_AnyString pm_AnyString_from_char "AnyString" (char *)
    cdef pm_AnyString pm_AnyString_from_string "AnyString" (string)

cdef extern from "polymake/Main.h" namespace "polymake":
    cdef cppclass Main:
        void set_application(char*)
        void set_preference(char*)

cdef extern from "polymake/Integer.h" namespace 'polymake':
    ctypedef pm_const_Integer "const Integer"
    cdef cppclass pm_Integer "Integer" :
        mpz_t get_rep()
        Py_ssize_t strsize(int)
        int compare(int)


# in beta, explicit casts defined
#       long to_long()   # FIXME: this is const
#       double to_double()

# in beta, set gets renamed into copy_from
        pm_Integer set_mpz_t "copy_from" (mpz_t)
        pm_Integer& set_mpz_srcptr "copy_from" (mpz_srcptr)

# in beta, non_zero replaced by is_zero
#        bool non_zero()
        bool is_zero()

        bool operator== (pm_Integer)
        bool operator== (long)
        bool operator> (pm_Integer)
        bool operator> (long)
        bool operator< (pm_Integer)
        bool operator< (long)

        int compare(pm_Integer)
        int compare(long)

        pm_Integer operator+ (pm_Integer)
        pm_Integer operator+ (long)
        pm_Integer operator- ()
        pm_Integer operator- (pm_Integer)
        pm_Integer operator- (long)
        pm_Integer operator* (pm_Integer)
        pm_Integer operator* (long)
        pm_Integer operator/ (pm_Integer)
        pm_Integer operator/ (long)
        pm_Integer negate()

cdef extern from "polymake/Rational.h" namespace 'polymake':
    ctypedef pm_const_Rational "const Rational"
    cdef cppclass pm_Rational "Rational":
        mpq_srcptr get_rep()
# in beta, set replaced by copy_from
        pm_Rational set_mpq_t "copy_from" (mpq_t)
        pm_Rational& set_mpq_srcptr "copy_from" (mpq_srcptr)
        pm_Rational& set_long "set" (long, long)

        pm_Rational abs()

# in beta, non_zero replaced by is_zero
#        bool non_zero()
        bool is_zero()

        bool operator== (pm_Rational)
        bool operator== (pm_Integer)
        bool operator== (long)
        bool operator< (pm_Rational)
        bool operator< (pm_Integer)
        bool operator< (long)
        bool operator> (pm_Rational)
        bool operator> (pm_Integer)
        bool operator> (long)

        int compare(pm_Rational)
        int compare(pm_Integer)
        int compare(long)

        pm_Rational operator+ (pm_Rational)
        pm_Rational operator+ (pm_Integer)
        pm_Rational operator+ (long)
        pm_Rational operator- ()
        pm_Rational operator- (pm_Rational)
        pm_Rational operator- (pm_Integer)
        pm_Rational operator- (long)
        pm_Rational operator* (pm_Rational)
        pm_Rational operator* (pm_Integer)
        pm_Rational operator* (long)
        pm_Rational operator/ (pm_Rational)
        pm_Rational operator/ (pm_Integer)
        pm_Rational operator/ (long)


cdef extern from "polymake/client.h":
    cdef cppclass pm_PerlPropertyValue "perl::PropertyValue":
        pass

    cdef cppclass pm_PerlObject "perl::Object":
        pm_PerlObject()
        pm_PerlObject(pm_AnyString) except +ValueError
        bool valid()
        void VoidCallPolymakeMethod(char*) except +ValueError
        void save(char*)
#
        pm_PerlPropertyValue take(pm_AnyString&)
        pm_PerlPropertyValue give(pm_AnyString&) # do not add except here, see pm_get for why
        pm_PerlObjectType type()
        int exists(const string& name)
        string name()
        string description()
        bool isa(pm_PerlObjectType)
        pm_PerlObject parent()

    cdef cppclass pm_PerlObjectType "perl::ObjectType":
        string name()

# in beta, CallPolymakeFunction is deprecated in favor of
#   call_method and call_function
#    pm_PerlObject CallPolymakeFunction (char*) except +ValueError
#    pm_PerlObject CallPolymakeHelp "CallPolymakeFunction" \
#            (char *, char *) except +ValueError
#    pm_PerlObject CallPolymakeFunction1 "CallPolymakeFunction" \
#            (char*, int) except +ValueError
#    pm_PerlObject CallPolymakeFunction2 "CallPolymakeFunction" \
#            (char*, int, int) except +ValueError
#    pm_PerlObject CallPolymakeFunction3 "CallPolymakeFunction" \
#            (char*, int, int, int) except +ValueError
    pm_PerlObject call_function(pm_AnyString) except +ValueError
    pm_PerlObject call_function1 "call_function" (pm_AnyString, int) except +ValueError
    pm_PerlObject call_function2 "call_function" (pm_AnyString, int, int) except +ValueError
    pm_PerlObject call_function3 "call_function" (pm_AnyString, int, int, int) except +ValueError

    pm_PerlObject* new_PerlObject_from_PerlObject "new perl::Object" (pm_PerlObject)

cdef extern from "polymake/Array.h" namespace "polymake":
    cdef cppclass pm_ArrayInt "Array<long>":
        pm_ArrayInt()
        pm_ArrayInt(int)
        int size()
        bool empty()
        void clear()
        void resize(int)
        void assign(int, long)
        long get "operator[]" (int i)
    cdef cppclass pm_ArrayString "Array<char *>":
        pm_ArrayString()
        pm_ArrayString(int)
        int size()
        bool empty()
        void clear()
        void resize(int)
        void assign(int, char *)
        char * get "operator[]" (int i)

cdef extern from "polymake/Set.h" namespace "polymake":
    cdef cppclass pm_SetInt "Set<long>":
        pm_SetInt()
        void clear()
        void resize(int)

cdef extern from "polymake/Matrix.h" namespace "polymake":
    cdef cppclass pm_MatrixRational "Matrix<Rational>":
        pm_MatrixRational()
        pm_MatrixRational(int nr, int nc)
        void assign(int r, int c, pm_Rational val)
        pm_MatrixRational operator|(pm_MatrixRational)
        Py_ssize_t rows()
        Py_ssize_t cols()

    cdef cppclass pm_MatrixInteger "Matrix<Integer>":
        pm_MatrixInteger()
        pm_MatrixInteger(int nr, int nc)
        void assign(int r, int c, pm_Integer val)
        pm_MatrixInteger operator|(pm_MatrixInteger)
        Py_ssize_t rows()
        Py_ssize_t cols()

    cdef cppclass pm_MatrixInt "Matrix<long>":
        pm_MatrixInt()
        pm_MatrixInt(int nr, int nc)
        void assign(int r, int c, long val)
        pm_MatrixInt operator|(pm_MatrixInt)
        Py_ssize_t rows()
        Py_ssize_t cols()

    # WRAP_CALL(t,i,j) -> t(i,j)
    pm_Rational mat_rational_get_element "WRAP_CALL"(pm_MatrixRational, int i, int j)
    pm_Integer mat_integer_get_element "WRAP_CALL"(pm_MatrixInteger, int i, int j)
    long mat_int_get_element "WRAP_CALL" (pm_MatrixInt, int i, int j)

#cdef extern from "polymake/GenericVector.h" namespace 'polymake':
    pm_MatrixRational ones_vector_Rational "ones_vector<Rational>" ()

#cdef extern from "polymake/GenericMatrix.h" namespace 'polymake':
    pm_MatrixRational unit_matrix_Rational "unit_matrix<Rational>" (int dim)


    # WRAP_OUT(x,y) x<<y
    void pm_assign_MatrixRational "WRAP_OUT" (pm_PerlPropertyValue, pm_MatrixRational)

    # the except clause below is fake
    # it is used to catch errors in PerlObject.give(), however adding
    # the except statement to the declaration of give() makes cython
    # split lines like
    #        pm_get(self.pm_obj.give(prop), pm_res)
    # and store the result of give() first. This causes problems since
    # pm_PerlPropertyValue doesn't have a default constructor.

    # WRAP_IN(x,y) x>>y
    void pm_get_float "WRAP_IN" (pm_PerlPropertyValue, float) except +ValueError
    void pm_get_Integer "WRAP_IN" (pm_PerlPropertyValue, pm_Integer) except +ValueError
    void pm_get_Rational "WRAP_IN" (pm_PerlPropertyValue, pm_Rational) except +ValueError
    void pm_get_ArrayInt "WRAP_IN" (pm_PerlPropertyValue, pm_ArrayInt) except +ValueError
    void pm_get_ArrayString "WRAP_IN" (pm_PerlPropertyValue, pm_ArrayString) except +ValueError
    void pm_get_MatrixInt "WRAP_IN" (pm_PerlPropertyValue, pm_MatrixInt) except +ValueError
    void pm_get_MatrixRational "WRAP_IN" (pm_PerlPropertyValue, pm_MatrixRational) except +ValueError
    void pm_get_MatrixInteger "WRAP_IN" (pm_PerlPropertyValue, pm_MatrixInteger) except +ValueError
    void pm_get_VectorInteger "WRAP_IN" (pm_PerlPropertyValue, pm_VectorInteger) except +ValueError
    void pm_get_VectorRational "WRAP_IN" (pm_PerlPropertyValue, pm_VectorRational) except +ValueError
    void pm_get_PerlObject "WRAP_IN" (pm_PerlPropertyValue, pm_PerlObject) except +ValueError

cdef extern from "polymake/Vector.h" namespace 'polymake':
    cdef cppclass pm_VectorInteger "Vector<Integer>":
        pm_VectorInteger()
        pm_VectorInteger(int nr)
        pm_Integer get "operator[]" (int i)
        int size()

    cdef cppclass pm_VectorRational "Vector<Rational>":
        pm_VectorRational()
        pm_VectorRational(int nr)
        pm_Rational get "operator []" (int i)
        int size()
