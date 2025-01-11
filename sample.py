#
# Sample program to use binio.f90 and forbit.py
#
# Provided by Kosei Ohara
#

import numpy as np

from forbit import forbit

nx = 288
ny = 145
nz = 45
shape = [nx,ny,nz]
kind = 4

nt = 10

ifile = 'input.bin'
ofile = 'output.bin'

# Input File
iclass = forbit(filename=ifile          , \
                action  ='read'         , \
                shape   =shape          , \
                kind    =kind           , \
                record  =1              , \
                recstep =1              , \
                endian  ='little_endian', \
                order   ='C'              )

# Output File
oclass = forbit(filename=ofile          , \
                action  ='write'        , \
                shape   =shape          , \
                kind    =kind           , \
                record  =1              , \
                recstep =1              , \
                endian  ='little_endian', \
                order   ='C'              )

work = np.empty(shape)
# Read a file and write the data to another file
for t in range(nt):
    work = iclass.fread()
    oclass.fwrite(work)

iclass.close()
oclass.close()

