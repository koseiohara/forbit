# FORtran-based Binary-io Interface Toolkit (FORBIT)
Programmer : Kosei Ohara  

Python programmers can read no-header binary files with this class like Fortran programmers. This module, `binio.f90`, is based on Fortran and wrapped by the class `forbit.pyx` written in Cython.  
This toolkit is available for up to 3 dimension data, but you can apply this for more than 4 dimension data by simple modification.

## Test Environment
CentOS Linux 7  
Python 3.7.7 :: Intel Corporation  
Cython 0.29.21
NumPy 1.21.6  

Python environment is based on pip  

## Compile and Path
Enter "make" to compile the source code
```shell-session
$ make
$ make install
```
`libbinio.so` and `forbit.cpython-37m-x86_64-linux-gnu.so` will be generated in my environment.
`make install` will copy these files to the directory specified by `LIB_INSTALL` in the `Makefile`.  
Note that `LIB_INSTALL` directory need to be added to `$LD_LIBRARY_PATH` by
```shell-session
$ export LD_LIBRARY_PATH="${YOUR_PATH}:${LD_LIBRARY_PATH}"
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
  Shape should be in Column-Major order, similar to Fortran, like `[nx,ny,nz]`.  
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
Two options are available, but both `newRecord` and `increment` are provided, `increment` value will be ignored.  
- newRecord  
  `type=int`  
  To assign a specific value to record, this parameter can be used. The record will be changed to this value.  
- increment  
  `type=int`  
  To add a specific value to record, this parameter can be used. This value will be added to the previous record.  





