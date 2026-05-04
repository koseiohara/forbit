# FORtran-based Binary-io Interface Toolkit (FORBIT)
Programmer : Kosei Ohara  

forbit is a Python interface to read/write Fortran direct-access unformatted binary files as NumPy ndarray, based on Fortran and Cython.
This toolkit is available for up to 6 dimension data.

## Test Environment
CentOS Linux 7  
Python 3.7.7 :: Intel Corporation  
Cython 0.29.21  
NumPy 1.21.6  

Python environment is based on pip  

## Compile and Path
To install this library via `pip`:
```shell-session
$ pip install forbit
```
Enter "make" to compile the source code
To install via `git clone`:
```shell-session
$ git clone https://github.com/koseiohara/forbit.git
$ cd forbit/src/
$ make
$ make install
```
If `git clone` is used, `libbinio.so` and `forbit.cpython-37m-x86_64-linux-gnu.so` will be generated in my environment.
`make install` will copy these files to the directory specified by `LIB_INSTALL` in the `Makefile`.  
Note that `LIB_INSTALL` directory need to be added to `$LD_LIBRARY_PATH` by
```shell-session
$ export PYTHONPATH="${YOUR_PATH}:${PYTHONPATH}" 
$ export LD_LIBRARY_PATH="${YOUR_PATH}:${LD_LIBRARY_PATH}"
```

## Usages
```python
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
```

```python
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
# record 1 -> 10
for t in range(nt):
    print(f"Record: {file.get_record()}")

    arr[:,:,:] = rng.random(shape)
    file.fwrite(arr[:,:,:])

    print(f"{arr[:,:,:]}\n")

file.close()
```

## Arguments
### forbit.\_\_init\_\_
By initializing this class, a binary file will be opened based on the arguments.  
- filename  
  `type=str`  
  File name of a no-header binary file.  
- action  
  `type=str`  
  `'read'` for input, `'write'` for output, or `'readwrite'` for both.  
  Either lowercase or uppercase characters are acceptable.  
- shape  
  `type=ndarray`  
  Other types of array such as `list` and `tuple` may be allowed.  
  Shape of input/output data.  
  Shape should be in Row-Major order, unlike Fortran, like `[nz,ny,nx]`.  
- kind  
  `type=int`  
  Kind parameter.  
  4 for single precision and 8 for double precision.  
  Quadruple precision is not supported.  
  Note that this parameter is not for your array, but rather for binary files.
  When you compute in double precision and output in single precision, `kind=4`.  
- record  
  `type=int`  
  Initial record to access.
- recstep  
  `type=int`  
  The value to increment record after every access.  
  If `recstep=0`, record will not be updated.  
- endian  
  `type=str`  
  Endian of file.  
  `'little_endian'` or `'big_endian'`.  
  Either lowercase or uppercase characters are acceptable.  

### forbit.close
Close the file. No argument is needed.

### forbit.fread
Read the file. No argument is needed. The shape of return is the same as specified in `forbit.__init__`.  
Note that the returned object is Row-Major like `[nz,ny,nx]`.  
Although various functions, such as `fread_sp1` and `fread_dp2`, are defined in this class, you just need to call `fread` as a suitable fread-related function is chosen in `forbit.__init__`.  

### forbit.fwrite
Write to the file.  
Note that the array for the argument have to be Row-Major like `[nz,ny,nx]`.  
Although various functions, such as `fwrite_sp1` and `fwrite_dp2`, are defined in this class, you just need to call `fwrite` as a suitable fread-related function is chosen in `forbit.__init__`.  
- arr  
  `type=ndarray`  
  Output data.  
  The shape of array must be the same as specified in `forbit.__init__`.  

### forbit.get\_record
Get the present record. No argument is needed. The type of return will be `int`.  

### forbit.reset\_record
Update the record.  
To update the record manually, this function have to be called because the record is encapsulated.  
Two options are available, but if both `newRecord` and `increment` are provided, `increment` value will be ignored.  
- newRecord  
  `type=int`  
  To assign a specific value to record, this parameter can be used. The record will be changed to this value.  
- increment  
  `type=int`  
  To add a specific value to record, this parameter can be used. This value will be added to the previous record.  





