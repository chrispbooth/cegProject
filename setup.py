from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize
from Cython.Distutils import build_ext

ext_modules = [
    Extension(
        "simpSent",
        ["simpSent.pyx"],
        extra_compile_args=['-fopenmp'],
        extra_link_args=['-fopenmp'],
    )
]

setup(
    name='simple-sentiment',
    ext_modules=cythonize(ext_modules),
)