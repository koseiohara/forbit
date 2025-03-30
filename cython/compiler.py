from setuptools   import setup, Extension
from Cython.Build import cythonize
import sys
import numpy as np

MOD    = sys.argv[1]
SRC    = sys.argv[2]
#CFLAG  = ['-O2', '-Wall', '-std=c99']
CFLAG  = ['-O2', '-Wall']
IPATH  = []
LIB    = ['binio']
LPATH  = ['.']
DEFINE = []     # SAMPLE : [("N", "10"), ("NX", 288")]

extensions = [
    Extension(
        name           =MOD                     ,
        sources        =[SRC]                   ,
        include_dirs   =[np.get_include()]+IPATH,
        libraries      =LIB                     ,
        library_dirs   =LPATH                   ,
        define_macros  =DEFINE                  ,
        extra_link_args=['-limf']
    )
]
setup(ext_modules        = cythonize(extensions)    ,
      script_args        =['build_ext', '--inplace'],  
      compiler_directives={'language_level':3}
)

