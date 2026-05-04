
### Read sample.grd ###
import numpy as np
import forbit

raw_binary_file = "sample.grd"
nx = 3
ny = 4
nz = 2
shape   = [nz,ny,nx]
kind    = 4                 ## Kind Parameter
endian  = "little_endian"   ## Endian of the Target File
record  = 1                 ## Initial Record
recstep = 1                 ## Record Increment

if (kind == 4):
    arr_type = np.float32
elif (kind == 8):
    arr_type = np.float64

arr = np.empty(shape, dtype=arr_type)

file = forbit.open(raw_binary_file ,
                   action ="read"  ,
                   shape  =shape   ,
                   kind   =kind    ,
                   record =record  ,
                   recstep=recstep,
                   endian =endian  )

nt = 10     ## Number of TImesteps
# record 1 -> 100
for t in range(nt):
    print(f"Record: {file.get_record()}")

    arr[:,:,:] = file.fread()
    ## Write any processes here

    print(f"{arr[:,:,:]}\n")

record = 16
nt = 5      ## Number of TImesteps
file.reset_record(newRecord=record)
# record 300 -> 399
for t in range(nt):
    print(f"Record: {file.get_record()}")

    arr[:,:,:] = file.fread()
    ## Write any processes here

    print(f"{arr[:,:,:]}\n")

file.close()


