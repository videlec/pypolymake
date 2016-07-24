#!/usr/bin/env python
r"""
Installation script for pypolymake

It depends on distutils
"""

from distutils.cmd import Command
from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize
from Cython.Distutils import build_ext

import os

extensions = [
    Extension("cygmp.utils",
        ["src/cygmp/utils.pyx"],
        depends = ["src/cygmp/*"],
        libraries = ["gmp"],
        language = 'c'),
    Extension("polymake.number",
        ["src/polymake/number.pyx"],
        depends = ["src/cygmp/*", "src/polymake/defs.pxd"],
        libraries = ["gmp", "polymake", "xml2", "perl"],
        language = 'c++'),
    Extension("polymake.vector",
        ["src/polymake/vector.pyx"],
        depends = ["src/cygmp/*", "src/polymake/defs.pxd"],
        libraries = ["gmp", "polymake", "xml2", "perl"],
        language = 'c++'),
    Extension("polymake.matrix",
        ["src/polymake/matrix.pyx"],
        depends = ["src/cygmp/*", "src/polymake/defs.pxd"],
        libraries = ["gmp", "polymake", "xml2", "perl"],
        language = 'c++'),
    Extension("polymake.polytope",
        ["src/polymake/polytope.pyx"],
        depends = ["src/cygmp/*", "src/polymake/defs.pxd"],
        libraries = ["gmp", "polymake", "xml2", "perl"],
        language = 'c++')
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
        doctest.testmod(polymake.polytope)

        # run the tests in the tests/ repo
        import os
        from subprocess import call
        for f in os.listdir('tests'):
            if f.startswith('test_') and f.endswith('.py'):
                f = os.path.join("tests", f)
                print "running tests in {}".format(f)
                if call(["python", f]) != 0:
                    raise RuntimeError("some tests failed in {}".format(f))

setup(
  name = "pypolymake",
  author ="Vincent Delecroix, Burcin Erocal",
  author_email = "sage-devel@googlegroups.com",
  version = open("VERSION").read().strip(),
  description = "Python wrapper for polymake",
  long_description = open("README").read(),
  license = "GNU General Public License, version 3 or later",
  ext_modules = extensions,
  packages = ["polymake", "cygmp"],
  package_dir = {"polymake": os.path.join("src", "polymake"),
                 "cygmp": os.path.join("src", "cygmp")},
  package_data = {"polymake": ["*.pxd", "*.h"],
                  "cygmp": ["*.pxd", "*.h"]},
  cmdclass = {'build_ext': build_ext, 'test': TestCommand}
)
