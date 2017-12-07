from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize
from Cython.Distutils import build_ext

ext_modules = [
    Extension(
        "cySent1",
        ["cySent1.pyx"],
        extra_compile_args=['-fopenmp'],
        extra_link_args=['-fopenmp'],
    )
]

setup(
    name='parallel-sentiment',
    ext_modules=cythonize(ext_modules),
)