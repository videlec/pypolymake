#from sage.matrix.matrix_rational_dense cimport Matrix_rational_dense
#from sage.modules.vector_integer_dense cimport Vector_integer_dense
#from sage.structure.sage_object cimport SageObject
#from sage.rings.integer cimport Integer as SageInteger
#from sage.rings.rational cimport Rational as SageRational
#from sage.libs.gmp.mpz cimport mpz_set
#from sage.libs.gmp.mpq cimport mpq_set
#from sage.rings.all import QQ, ZZ
#from sage.matrix.matrix_space import MatrixSpace

#cdef Vector_integer_dense pm_VectorInteger_to_sage(VectorInteger pm_vec):
#    r"""
#    Convert a polymake Vector<Integer> to a Sage Vector_integer_dense
#    """
#    cdef Py_ssize_t size = pm_vec.size()
#    # this seems to be a rather unreliable way to getting a new element
#    # even though it is documented to work in the comments of zero_vector()
#    cdef Vector_integer_dense svec = (ZZ**size).zero_vector()
#    cdef Py_ssize_t i
#    for i in range(size):
#        mpz_set(svec._entries[i], pm_vec.get(i).get_rep())
#    return svec

#cdef Matrix_rational_dense pm_mat_to_sage(MatrixRational pm_mat):
#    """
#    Convert a polymake Matrix<Rational> to a Sage Matrix_rational_dense.
#    """
#    cdef Py_ssize_t nr = pm_mat.rows(), nc = pm_mat.cols()
#    cdef Matrix_rational_dense smat = MatrixSpace(QQ, nr, nc)() #zero matrix
#    cdef Py_ssize_t i, j
#    for i in range(nr):
#        for j in range(nc):
#            mpq_set(smat._matrix[i][j],
#                    get_element(pm_mat, i, j).get_rep())
#    return smat

#cdef MatrixRational* sage_mat_to_pm(Matrix_rational_dense mat):
#    """
#    Convert a Sage Matrix_rational_dense to a polymake Matrix<Rational>.
#    """
#    cdef Py_ssize_t nr = mat.nrows()
#    cdef Py_ssize_t nc = mat.ncols()
#    # create polymake matrix with dimensions of mat
#    cdef MatrixRational* pm_mat = new MatrixRational(nr, nc)
#    cdef Py_ssize_t i, j
#    cdef Rational *tmp_rat
#    # loop through the elements and assign values
#    for i in range(nr):
#        for j in range(nc):
#            get_element(pm_mat[0], i, j).set(mat._matrix[i][j])
#    return pm_mat


