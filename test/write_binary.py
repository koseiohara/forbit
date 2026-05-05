
### Write to sample.grd ###
import numpy as np
import forbit
import os

from get_info import get_shape, get_filename

os.makedirs("binary", exist_ok=True)

ndim_max = 6
endian   = "little_endian"      ## Endian of the Target File
record   = 1                    ## Initial Record
recstep  = 1                    ## Record Increment

rng = np.random.default_rng()       ## Random Generator

for kind in [4, 8]:         ## Kind Parameter
    print(f"kind={kind}")
    for ndim in range(1, ndim_max+1):       ## Dimension
        print(f"dim={ndim}")

        shape = get_shape(ndim)
        raw_binary_file = get_filename(ndim, kind)

        print(f"shape={shape}")

        if (kind == 4):
            arr_type = np.float32
        elif (kind == 8):
            arr_type = np.float64

        arr = np.empty(shape, dtype=arr_type)

        file = forbit.open(raw_binary_file,
                           action ="write",
                           shape  =shape  ,
                           kind   =kind   ,
                           record =record ,
                           recstep=recstep,
                           endian =endian )

        nt = 20     ## Number of Timesteps
        # record 1 -> 20
        for t in range(nt):
            print(f"Record: {file.get_record()}")

            arr[...] = rng.random(shape)
            file.fwrite(arr[...])
            # print(f"{arr[...]}\n")
            print(f"{'':4s}MIN={np.min(arr):0.15f}-{np.max(arr):0.15f}")

        file.close()
        print(f"dim={ndim}: COMPLETE\n")

    print(f"kind={kind}: COMPLETE\n")

print("TEST COMPLETE")

