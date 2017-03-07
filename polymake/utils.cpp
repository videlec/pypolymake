#include "utils.h"

std::string Integer_repr(polymake::Integer const &x)
{
	std::ostringstream oss;
    oss << x;
	return oss.str();
}
