
###############################################################################
#       Copyright (C) 2011-2012 Burcin Erocal <burcin@erocal.org>
#                     2016      Vincent Delecroix <vincent.delecroix@labri.fr>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

# This file contain header declarations from polymake (in include/core/polymake).
# The explicit list of supported "small objects" from polymake is declared
# in this file
#
#     AccurateFloat.h
#     AnyString.h
#     Array.h
#     Bitset.h
#     CascadedContainer.h
#     ContainerChain.h
#     ContainerUnion.h
#     EmbeddedList.h
#     EquivalenceRelation.h
#     FaceMap.h
#     FacetList.h
#     Fibonacci.h
#     GenericGraph.h
#     GenericIncidenceMatrix.h
#     GenericIO.h
#     GenericMatrix.h
#     GenericSet.h
#     GenericStruct.h
#     GenericVector.h
#     Graph.h
#     Heap.h
#     IncidenceMatrix.h
#     IndexedSubgraph.h
#     IndexedSubset.h
#     Integer.h
#     ListMatrix.h
#     Map.h
#     Matrix.h
#     MultiDimCounter.h
#     Plucker.h
#     Polynomial.h
#     PowerSet.h
#     PuiseuxFraction.h
#     QuadraticExtension.h
#     RandomGenerators.h
#     RandomSpherePoints.h
#     RandomSubset.h
#     RationalFunction.h
#     Rational.h
#     Ring.h
#     SelectedSubset.h
#     Series.h
#     Set.h
#     Smith_normal_form.h
#     SparseMatrix.h
#     SparseVector.h
#     TransformedContainer.h
#     TropicalNumber.h
#     Vector.h
#
#     client.h
#     color.h
#     integer_linalg.h
#     linalg.h
#     meta_function.h
#     meta_list.h
#     node_edge_incidences.h
#     numerical_functions.h
#     pair.h
#     permutations.h
#     socketstream.h
#     totally_unimodular.h
#     type_utils.h
#
# lib/callable/include/Main.h

from libcpp cimport bool
from libcpp.string cimport string
from .cygmp.types cimport mpz_t, mpq_t, mpz_srcptr, mpq_srcptr

cdef extern from "wrap.h":
    pass

cdef extern from "<utility>":
    cdef cppclass pairstringstring "std::pair<std::string, std::string>":
        string first
        string second
    cdef cppclass pairintint "std::pair<int,int>":
        int first
        int second

cdef extern from "polymake/Main.h" namespace "polymake":
    cdef cppclass Main:
        Main()
        Main(string)
        void set_application(string)
        void set_preference(string)
        void pm_include "include" (string)

cdef extern from "polymake/Integer.h" namespace "polymake":
    ctypedef pm_const_Integer "const Integer"
    cdef cppclass pm_Integer "Integer":
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

# header in source
#    include/core/polymake/Rational.h
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
        pm_PerlObject(string) except +ValueError
        bool valid()
        void VoidCallPolymakeMethod(char*) except +ValueError
        void save(char*)


# HOW DO WE ACCESS ELEMENTS OF ARRAYS, ETC?
#        long get_long_from_int "operator[]" (int i)
#        pm_PerlObject get_PerlObject_from_int "operator[]" (int i)

        pm_PerlPropertyValue take(string&)
        pm_PerlPropertyValue give(string&) # do not add except here, see pm_get for why
        pm_PerlObjectType type()
        int exists(const string& name)
        string name()
        string description()
        bool isa(pm_PerlObjectType)
        pm_PerlObject parent()

    cdef cppclass pm_PerlObjectType "perl::ObjectType":
#        pm_PerlObjectType(AnyString&)
        string name()
#        bool isa "isa" (AnyString&)

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

    pm_PerlObject call_function (string) except+
    pm_PerlObject call_function (string, int) except+
    pm_PerlObject call_function (string, int, int) except+
    pm_PerlObject call_function (string, int, int, int) except+
    pm_MapStringString call_function (string, pm_PerlObject) except+

    pm_PerlObject* new_PerlObject_from_PerlObject "new perl::Object" (pm_PerlObject)

cdef extern from "polymake/Array.h" namespace "polymake":
    cdef cppclass pm_ArrayBool "Array<bool>":
        int size()
        bool empty()
        bool get "operator[]" (int i)
    cdef cppclass pm_ArrayInt "Array<int>":
        int size()
        bool empty()
        long get "operator[]" (int i)
    cdef cppclass pm_ArrayRational "Array<Rational>":
        int size()
        bool empty()
        pm_Rational get "operator[]" (int i)
    cdef cppclass pm_ArrayString "Array<std::string>":
        int size()
        bool empty()
        string get "operator[]" (int i)
    cdef cppclass pm_ArrayMatrixInteger "Array<Matrix<Integer>>":
        int size()
        bool empty()
        pm_MatrixInteger "operator[]" (int i)
    cdef cppclass pm_ArraySetInt "Array<Set<int>>":
        int size()
        bool empty()
        pm_SetInt get "operator[]" (int i)
    cdef cppclass pm_ArrayArrayInt "Array<Array<int>>":
        int size()
        bool empty()
        pm_ArrayInt get "operator[]" (int i)
    cdef cppclass pm_ArrayPairStringString "Array<std::pair<std::string,std::string>>":
        int size()
        bool empty()
        pairstringstring get "operator[]" (int i)
    cdef cppclass pm_ArrayArrayPairStringString "Array<Array<std::pair<std::string,std::string>>>":
        int size()
        bool empty()
        pm_ArrayPairStringString get "operator[]" (int i)
    cdef cppclass pm_ArrayPowerSetInt "Array<PowerSet<int>>":
        int size()
        bool empty()
        pm_PowerSetInt get "operator[]" (int i)

cdef extern from "polymake/Set.h" namespace "polymake":
    cdef cppclass pm_SetInt "Set<int>":
        pm_SetInt()
        void clear()
        void resize(int)
        int size()
        bool empty()
        # iterator begin() const
        # iterator end() const
        # reverse_iterator rbegin()
        # reverse_iterator rend()

    cdef cppclass pm_SetSetInt "Set<Set<int>>":
        int size()
    cdef cppclass pm_SetMatrixRational "Set<Matrix<Rational>>":
        int size()

cdef extern from "polymake/Map.h" namespace "polymake":
    cdef cppclass pm_MapStringString "Map<std::string,std::string>":
        string get "operator[]" (string&)
        int size()
        bool exists(string&)
    cdef cppclass pm_MapRationalRational "Map<Rational, Rational>":
        pm_Rational get "operator[]" (pm_Rational&)
        int size()
        bool exists(pm_Rational&)
    cdef cppclass pm_MapIntInt "Map<int, int>":
        int get "operator[]" (int)
        int size()
        bool exists(int)
    cdef cppclass pm_MapIntegerInt "Map<Integer, int>":
        int get "operator[]" (pm_Integer)
        int size()
        bool exists(pm_Integer&)


cdef extern from "polymake/IncidenceMatrix.h" namespace "polymake":
    cdef cppclass pm_IncidenceMatrixNonSymmetric "IncidenceMatrix<NonSymmetric>":
        pm_IncidenceMatrixNonSymmetric()
        pm_IncidenceMatrixNonSymmetric(int nr, int nc)
        Py_ssize_t rows()
        Py_ssize_t cols()

# SparseMatrix<Rational, NonSymmetric>"
# SparseMatrix<Rational, Symmetric>"
cdef extern from "polymake/SparseMatrix.h" namespace "polymake":
    cdef cppclass pm_SparseMatrixIntNonSymmetric "SparseMatrix<int, NonSymmetric>":
        pm_SparseMatrixInt ()
        pm_SparseMatrixInt (int nr, int nc)
        Py_ssize_t rows()
        Py_ssize_t cols()


    cdef cppclass pm_SparseMatrixRationalNonSymmetric "SparseMatrix<Rational, NonSymmetric>":
        pm_SparseMatrixRational ()
        pm_SparseMatrixRational (int nr, int nc)
        Py_ssize_t rows()
        Py_ssize_t cols()



# NOTE: for Matrix the C++ type does not match the perl type
# namely, the "" part is fake
cdef extern from "polymake/Matrix.h" namespace "polymake":
    cdef cppclass pm_MatrixInt "Matrix<int>":
        pm_MatrixInt()
        pm_MatrixInt(int nr, int nc)
        void assign(int r, int c, int val)
        Py_ssize_t rows()
        Py_ssize_t cols()

    cdef cppclass pm_MatrixFloat "Matrix<float>":
        pm_MatrixFloat()
        pm_MatrixFloat(int nr, int nc)
        void assign(int r, int c, float val)
        Py_ssize_t rows()
        Py_ssize_t cols()

    cdef cppclass pm_MatrixRational "Matrix<Rational>":
        pm_MatrixRational()
        pm_MatrixRational(int nr, int nc)
        void assign(int r, int c, pm_Rational val)
        Py_ssize_t rows()
        Py_ssize_t cols()

    cdef cppclass pm_MatrixInteger "Matrix<Integer>":
        pm_MatrixInteger()
        pm_MatrixInteger(int nr, int nc)
        void assign(int r, int c, pm_Integer val)
        Py_ssize_t rows()
        Py_ssize_t cols()

    cdef cppclass pm_MatrixQuadraticExtensionRational " Matrix<QuadraticExtension<Rational>>":
        pass

cdef extern from "polymake/Polynomial.h" namespace "polymake":
    cdef cppclass pm_UniPolynomialRationalInt "UniPolynomial<Rational, int>":
        int n_vars()
        int n_terms()
        bool trivial()
        bool unit()
        int deg()
        int lower_deg()

        pm_VectorRational coefficients_as_vector()
#        bool operator== (const UniPolynomial& other)
#        bool operator!= (const UniPolynomial& other)

cdef extern from "polymake/QuadraticExtension.h" namespace "polymake":
    cdef cppclass pm_QuadraticExtensionRational "QuadraticExtension<Rational>":
        pass

cdef extern from "polymake/RationalFunction.h" namespace "polymake":
    cdef cppclass pm_RationalFunctionRationalInt "RationalFunction<Rational, int>":
        pm_UniPolynomialRationalInt numerator()
        pm_UniPolynomialRationalInt denominator()

cdef extern from "polymake/Set.h" namespace "polymake":
    cdef cppclass pm_SetInt "Set<Int>":
        pass

#cdef extern from "polymake/GenericVector.h" namespace 'polymake':
#    pm_MatrixRational ones_vector_Rational "ones_vector<Rational>" ()

#cdef extern from "polymake/GenericMatrix.h" namespace 'polymake':
#    pm_MatrixRational unit_matrix_Rational "unit_matrix<Rational>" (int dim)


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
#    void pm_get_float "WRAP_IN" (pm_PerlPropertyValue, float) except +ValueError


cdef extern from "polymake/SparseMatrix.h" namespace "polymake":
    pass

# Vector<Int>
# Vector<Float>
# Vector<Integer>
# Vector<Rational>
cdef extern from "polymake/Vector.h" namespace 'polymake':
    cdef cppclass pm_VectorInt "Vector<int>":
        int get "operator[]" (int i)
        int size()
    cdef cppclass pm_VectorFloat "Vector<float>":
        float get "operator[]" (int i)
        int size()
    cdef cppclass pm_VectorInteger "Vector<Integer>":
        pm_Integer get "operator[]" (int i)
        int size()
    cdef cppclass pm_VectorRational "Vector<Rational>":
        pm_Rational get "operator []" (int i)
        int size()

cdef extern from "polymake/PowerSet.h" namespace "polymake":
    cdef cppclass pm_PowerSetInt "PowerSet<int>":
        int size()

cdef extern from "polymake/SparseVector.h" namespace "polymake":
    pass



