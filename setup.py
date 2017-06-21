#!/usr/bin/env python
r"""
Installation script for pypolymake

It depends on distutils
"""

from __future__ import print_function

from autogen.pm_types import pm_modules
from setuptools import setup
import distutils
from distutils.cmd import Command
from distutils.command.build_ext import build_ext as _build_ext
from setuptools.extension import Extension

import os


# temporary fix to
#   https://github.com/videlec/pypolymake/issues/17
cfg_vars = distutils.sysconfig.get_config_vars()
cfg_vars['CFLAGS'] = cfg_vars['CFLAGS'].replace("-Wstrict-prototypes", "")


extensions = [
    Extension("polymake.cygmp.utils", ["polymake/cygmp/utils.pyx"],
        depends = ["polymake/cygmp/*.pxd", "polymake/cygmp/*h"]),

    Extension("polymake.perl_object", ["polymake/perl_object.pyx"],
        depends = ["polymake/*.pxd", "polymake/cygmp/*"]),

    Extension("polymake.main", ["polymake/main.pyx"],
        depends = ["polymake/*.pxd", "polymake/cygmp/*"]),

    Extension("polymake.handlers", ["polymake/handlers.pyx"],
        depends = ["polymake/*.pxd", "polymake/cygmp/*"]),

#    Extension("polymake.function_dispatcher", ["polymake/function_dispatcher.pyx"],
#        depends = ["polymake/*.pxd", "polymake/cygmp/*"]),

    Extension("polymake.big_object", ["polymake/big_object.pyx"],
        depends = ["polymake/*.pxd", "polymake/cygmp/*"]),
]



for mod in pm_modules():
    extensions.append(
        Extension("polymake." + mod, ["polymake/" + mod + ".pyx"],
            depends = ["polymake/*.pxd", "polymake/cygmp/*"]),
    )

try:
    import sage.all
    import sage
    import sage.env
    compile_from_sage = True
except ImportError:
    compile_from_sage = False

if compile_from_sage:
    import site
    extensions.append(
        Extension("polymake.sage_conversion", ["polymake/sage_conversion.pyx"],
        depends = ["polymake/defs.pxd"],
        include_dirs = site.getsitepackages())
    )
    #TODO: if include_dirs not set we end up with the following error
    #
    #    gcc -fno-strict-aliasing -g -O2 -DNDEBUG -g -fwrapv -O3 -Wall -Wno-unused -fPIC -I/opt/sage/local/include/python2.7 -c src/polymake/sage_conversion.cpp -o build/temp.linux-x86_64-2.7/src/polymake/sage_conversion.o
    #    src/polymake/sage_conversion.cpp:480:35: erreur fatale : sage/libs/ntl/ntlwrap.h : Aucun fichier ou dossier de ce type
    #     #include "sage/libs/ntl/ntlwrap.h"

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
                print("running tests in {}".format(f))
                if call(["python", f]):
                    raise RuntimeError("some tests failed in {}".format(f))



# Adapted from Cython's new_build_ext
class build_ext(_build_ext):
    def finalize_options(self):
        # Generate files
        from autogen import rebuild
        rebuild()


        import sys

        # Check dependencies
        try:
            from Cython.Build.Dependencies import cythonize
        except ImportError as E:
            sys.stderr.write("Error: {0}\n".format(E))
            sys.stderr.write("The installation of ppl requires Cython\n")
            sys.exit(1)

# cysignals not yet integrated
#        try:
#            # We need the header files for cysignals at compile-time
#            import cysignals
#        except ImportError as E:
#            sys.stderr.write("Error: {0}\n".format(E))
#            sys.stderr.write("The installation of ppl requires cysignals\n")
#            sys.exit(1)


        compile_time_env = {}
        if compile_from_sage:

            version = sage.env.SAGE_VERSION.split('.')
            major = int(version[0])
            minor = int(version[1])
            if len(version) == 3:
                beta = int(version[2][4:])
            else:
                beta = -1
            sage_version = (major,minor,beta)

            # trac ticket #22970 changes datastructure of rational matrices
            # merged in 8.0.beta9
            compile_time_env['SAGE_RAT_MAT_ARE_FMPQ_T_MAT'] = (sage_version >= (8,0,9))

        self.distribution.ext_modules[:] = cythonize(
            self.distribution.ext_modules,
            compile_time_env=compile_time_env,
            include_path=sys.path)
        _build_ext.finalize_options(self)


setup(
  name = "pypolymake",
  author ="Vincent Delecroix, Burcin Erocal",
  author_email = "sage-devel@googlegroups.com",
  version = open("VERSION").read().strip(),
  description = "Python wrapper for polymake",
  long_description = open("README").read(),
  license = "GNU General Public License, version 3 or later",
  ext_modules = extensions,
  packages = ["polymake", "polymake.cygmp"],
  package_dir = {"polymake": "polymake",
                 "polymake.cygmp": os.path.join("polymake", "cygmp")},
  package_data = {"polymake": ["*.pxd", "*.pyx", "*.h"],
                  "polymake.cygmp": ["*.pxd", "*.pyx", "*.h"]},
  cmdclass = {'build_ext': build_ext, 'test': TestCommand}
)
