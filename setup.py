#!/usr/bin/env python
r"""
Installation script for pypolymake

It depends on distutils
"""

from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize
from Cython.Distutils import build_ext

import os

try:
    SAGE_LOCAL = os.environ['SAGE_LOCAL']
    SAGE_ROOT = os.environ['SAGE_ROOT']
except KeyError:
    raise ValueError("pypolymake installation failed!\n"
                     "SAGE_LOCAL and SAGE_ROOT should be defined.\n"
                     "Perhaps you are not inside a Sage shell.")

includes = [
    os.path.join('src', 'pypolmake'),
    os.path.join(SAGE_LOCAL, 'include'),
    os.path.join(SAGE_ROOT, 'src')
]

extensions = [
    Extension("cygmp.utils",
        ["src/cygmp/utils.pyx"],
        language = 'c'),
    Extension("polymake.number",
        ["src/polymake/number.pyx"],
        language = 'c++',
        include_dirs = includes),
    Extension("polymake.vector",
        ["src/polymake/vector.pyx"],
        language = 'c++',
        include_dirs = includes),
    Extension("polymake.matrix",
        ["src/polymake/matrix.pyx"],
        language = 'c++',
        include_dirs = includes),
    Extension("polymake.polytope",
        ["src/polymake/polytope.pyx"],
        language = 'c++')
]

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
  cmdclass = {'build_ext': build_ext}
)
