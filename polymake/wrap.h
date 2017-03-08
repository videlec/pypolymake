#include <polymake/Main.h>
#include <polymake/Matrix.h>
#include <polymake/Rational.h>


#define WRAP_OUT(x,y) x << y
#define GIVE(ans, obj, prop)  (obj)->give(prop) >> ans
#define CALL_METHOD(ans, obj, prop) (obj)->call_method(prop) >> ans
#define WRAP_CALL(t, i, j) t(i,j)



/* this should not be needed... however Cython gets mad if not there */
using namespace polymake;
