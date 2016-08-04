#!/usr/bin/env python
r"""
Installation script for pypolymake

It depends on distutils
"""

from distutils.cmd import Command
from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

import os

extensions = [
    Extension("cygmp.utils",
        ["src/cygmp/utils.pyx", "src/cygmp/pylong.c",],
        depends = ["src/cygmp/all.pxd", "src/cygmp/mpq.pxd",
            "src/cygmp/random.pxd", "src/cygmp/utils.pyx",
            "src/cygmp/misc.pxd", "src/cygmp/mpn.pxd",
            "src/cygmp/mpz.pxd", "src/cygmp/python_extra.h",
            "src/cygmp/types.pxd", "src/cygmp/utils.pxd"],
        libraries = ["gmp"],
        language = 'c'),

    Extension("polymake.number",
        ["src/polymake/number.pyx"],
        depends = ["src/polymake/defs.pxd"],
        libraries = ["gmp", "polymake", "xml2", "perl"],
        language = 'c++'),

    Extension("polymake.vector",
        ["src/polymake/vector.pyx"],
        depends = ["src/polymake/defs.pxd"],
        libraries = ["gmp", "polymake", "xml2", "perl"],
        language = 'c++'),

    Extension("polymake.matrix",
        ["src/polymake/matrix.pyx"],
        depends = ["src/polymake/defs.pxd"],
        libraries = ["gmp", "polymake", "xml2", "perl"],
        language = 'c++'),

    Extension("polymake.perl_object",
        ["src/polymake/perl_object.pyx"],
        depends = ["src/polymake/defs.pxd"],
        libraries = ["gmp", "polymake", "xml2", "perl"],
        language = 'c++'),

    Extension("polymake.properties",
        ["src/polymake/properties.pyx"],
        depends = ["src/polymake/defs.pxd"],
        libraries = ["gmp", "polymake", "xml2", "perl"],
        language = 'c++'),

    Extension("polymake.polytope",
        ["src/polymake/polytope.pyx"],
        depends = ["src/polymake/defs.pxd"],
        libraries = ["gmp", "polymake", "xml2", "perl"],
        language = 'c++'),

]

class TestCommand(Command):
    user_options = []

    def initialize_options(self):
        pass

    def finalize_options(self):
        pass

    def run(self):
        # run the doctests
        import doctest
        import polymake
        (failure_count, test_count) = doctest.testmod(polymake.functions,
                optionflags=doctest.ELLIPSIS)
        if failure_count:
            raise RuntimeError("{} test(s) failed in polymake.polytope".format(failure_count))

        # run the tests in the tests/ repo
        from subprocess import call
        for f in os.listdir('tests'):
            if f.startswith('test_') and f.endswith('.py'):
                f = os.path.join("tests", f)
                print "running tests in {}".format(f)
                if call(["python", f]):
                    raise RuntimeError("some tests failed in {}".format(f))

setup(
  name = "pypolymake",
  author ="Vincent Delecroix, Burcin Erocal",
  author_email = "sage-devel@googlegroups.com",
  version = open("VERSION").read().strip(),
  description = "Python wrapper for polymake",
  long_description = open("README").read(),
  license = "GNU General Public License, version 3 or later",
  ext_modules = cythonize(extensions),
  packages = ["polymake", "cygmp"],
  package_dir = {"polymake": os.path.join("src", "polymake"),
                 "cygmp": os.path.join("src", "cygmp")},
  package_data = {"polymake": ["*.pxd", "*.pyx", "*.h"],
                  "cygmp": ["*.pxd", "*.pyx", "*.h"]},
  cmdclass = {'test': TestCommand}
)
