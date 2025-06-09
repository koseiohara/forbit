# FORtran-based Binary-io Interface Toolkit (FORBIT)
Programmer : Kosei Ohara  

Direct access binary reader for Python.
Most users do not need to call binio directly; instead, `forbit.py` will be called.

## Test Environment
CentOS Linux 7  
Python 3.7.7 :: Intel Corporation  
NumPy 1.21.6  

Python environment is based on pip  

## Compile
Enter "make" to compile the source code
```shell-session
$ make
```
`binio.cpython-37m-x86_64-linux-gnu.so` will be generated in my environment.
After entering this command, binio is ready to be called.  
To remove `*.so` file, enter "make clean"
```shell-session
$ make clean
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
  `'little_eidnan'` or `'big_endian'`.  
  Either lowercase or uppercase characters are acceptable.  
- order  
  `type=str`  
  Order of memory.  
  `"C"` and `"F"` are valid. `"C"` for Row-Major, and `"F"` for Column-Major.  
  Although you set `order="C"`, argument `shape` must be defined in Column-Major.

### forbit.close
Close the file. No argument is needed.

### forbit.fread
Read the file. No argument is needed. The shape of return is the same as specified in `forbit.__init__`.  
Note that the returned object is Column-Major like `[nx,ny,nz]`.  
Although various functions, such as `fread_sp_1dim` and `fread_dp_2dim`, are defined in this class, you only need to call `fread` as a suitable fread-related function is chosen in `forbit.__init__`.  
If the input data contains `NaN`, warning message will be printed.  

### forbit.fwrite
Write to the file.  
Note that the array for the argument have to be Column-Major like `[nx,ny,nz]`.  
Although 2 functions, `fwrite_sp` and `fwrite_dp`, are defined in this class, you only need to call `fwrite` as a suitable fwrite-related function is chosen in `forbit.__init__`.
- dataArray  
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





