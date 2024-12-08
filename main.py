import numpy as np
from fileio import fileio

nx = 288
ny = 145
nz = 2
kind = 4

nt = 100

ifile = '/mnt/jet11/kosei/JRA/JRA3Q/ALL/JRA3Q_1990_2020/JRA3Q_1990_2020_ALL_PRES.bin'
ofile = 'pres.bin'

iclass = fileio(filename=ifile          , \
                action  ='read'         , \
                nx      =nx             , \
                ny      =ny             , \
                nz      =nz             , \
                kind    =4              , \
                record  =1              , \
                recstep =1              , \
                endian  ='little_endian'  )

oclass = fileio(filename=ofile          , \
                action  ='write'        , \
                nx      =nx             , \
                ny      =ny             , \
                nz      =nz             , \
                kind    =4              , \
                record  =1              , \
                recstep =1              , \
                endian  ='little_endian'  )

mean = np.zeros([nx,ny,nz])
work_reader = np.empty([nx,ny,nz])
for t in range(nt):
    work_reader[0:nx,0:ny] = iclass.fread()
    #work_reader[0:nx,0:ny,0:nz] = iclass.fread()
    mean[0:nx,0:ny,0:nz] = mean[0:nx,0:ny,0:nz] + work_reader[0:nx,0:ny]

mean[0:nx,0:ny,0:nz] = mean[0:nx,0:ny,0:nz] / float(nt)
oclass.fwrite(mean[0:nx,0:ny,0:nz])

iclass.close()
oclass.close()

