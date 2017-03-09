#ifndef _PYPOLYMAKE_WRAP_H
#define _PYPOLYMAKE_WRAP_H


#include <polymake/Main.h>
#include <polymake/Matrix.h>
#include <polymake/Rational.h>
#include <polymake/Map.h>


#define WRAP_OUT(x,y) x << y
#define WRAP_IN(x,y) x >> y

/* note: polymake objects can not write directly in c++ stream */
/* we need this magic wrap function */
#define WRAP_wrap_OUT(x,y) wrap(x) << y

#define GIVE(ans, obj, prop)  (obj)->give(prop) >> ans
#define CALL_METHOD(ans, obj, prop) (obj)->call_method(prop) >> ans
#define WRAP_CALL(t, i, j) t(i,j)

/* this should not be needed... however Cython gets mad if not there */
using namespace polymake;

#endif
