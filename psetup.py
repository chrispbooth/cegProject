from distutils.core import setup
from distutils.extension import Extension
from cython.Build import cythonize
from cython.Distutils import build_ext

ext_modules = [
    Extension(
        "cySent",
        ["cySent.pyx"],
        extra_compile_args=['-fopenmp'],
        extra_link_args=['-fopenmp'],
    )
]

setup(
    name='parallel-sentiment',
    ext_modules=cythonize(ext_modules),
)