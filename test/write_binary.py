### Write to sample.grd ###
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
                   action ="write" ,
                   shape  =shape   ,
                   kind   =kind    ,
                   record =record  ,
                   recstep=recstep,
                   endian =endian  )

rng = np.random.default_rng()       ## Random Generator
nt = 20     ## Number of TImesteps
# record 1 -> 20
for t in range(nt):
    print(f"Record: {file.get_record()}")

    arr[:,:,:] = rng.random(shape)
    file.fwrite(arr[:,:,:])

    print(f"{arr[:,:,:]}\n")

file.close()


