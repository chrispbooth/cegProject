from distutils.core import setup
from cython.Build import cythonize

setup(
    ext_modules=cythonize("cySent.pyx"),
)