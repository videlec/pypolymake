# distutils: language = c++
# distutils: libraries = polymake gmpxx gmp
###############################################################################
#       Copyright (C) 2016 Vincent Delecroix <vincent.delecroix@labri.fr> 
#
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 3 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

from libcpp cimport bool
from libcpp.string cimport string

include "auto_rational_function.pxi"
