import polymake
import doctest

(failure_count, test_count) = doctest.testmod(polymake.functions,
        optionflags=doctest.ELLIPSIS)

if failure_count:
    raise RuntimeError("{} test(s) failed in polymake.functions".format(failure_count))

