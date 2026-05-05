# FORtran-based Binary-io Interface Toolkit (FORBIT)
FORBIT is a Python package for reading and writing Fortran direct-access unformatted binary files as NumPy arrays.
It is designed for no-header binary files whose records are written by Fortran with `FORM='UNFORMATTED'`, `ACCESS='DIRECT'` and `FORM='UNFORMATTED'`.
The Python interface keeps track of the current Fortran record number, reads or writes one fixed-size record at a time, and returns ordinary `numpy.ndarray` objects.  

FORBIT brings lightweight direct-access binary I/O to NumPy ndarrays while keeping a workflow familiar to Fortran users.

## Features
- Read and write Fortran direct-access unformatted binary files
- Handle no-header fixed-record binary files with explicit Fortran-style workflows
- Return data as `numpy.ndarray`
- Support 1D to 6D arrays
- Support single precision and double precision floating-point data
- Support explicit endian selection through Fortran's `CONVERT` specifier
- Keep the current record number internally and update it after each read or write

## Requirements
FORBIT is implemented with Python, NumPy, Cython, and Fortran.
The package metadata declares support for CPython on POSIX/Linux with Python 3.7 to 3.13.  

Runtime dependency:
- NumPy  

Build dependencies:
- setuptools
- wheel
- Cython
- NumPy
- A Fortran compiler (default: gfortran)
- A C compiler (default: gcc)
- Makefile

The Fortran/C compilers can be configured in `src/Makefile`.

## Compile and Path
### Install from PyPI
```shell-session
$ pip install forbit
```
### Build from Source
```shell-session
$ git clone https://github.com/koseiohara/forbit.git
$ cd forbit/src/
$ make
$ make install
```
When building manually, `make install` copies the generated shared libraries to the directory specified by `LIB_INSTALL` in `src/Makefile`.
Add that directory to both `PYTHONPATH` and `LD_LIBRARY_PATH` before importing the module.
```shell-session
$ export PYTHONPATH="${YOUR_PATH}:${PYTHONPATH}" 
$ export LD_LIBRARY_PATH="${YOUR_PATH}:${LD_LIBRARY_PATH}"
```

## Examples
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

file = forbit.open(raw_binary_file,
                   action ="read" ,
                   shape  =shape  ,
                   kind   =kind   ,
                   record =record ,
                   recstep=recstep,
                   endian =endian )

nt = 20     ## Number of Timesteps
# record 1 -> 20
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

file = forbit.open(raw_binary_file,
                   action ="write",
                   shape  =shape  ,
                   kind   =kind   ,
                   record =record ,
                   recstep=recstep,
                   endian =endian )

rng = np.random.default_rng()       ## Random Generator
nt = 20     ## Number of Timesteps
# record 1 -> 20
for t in range(nt):
    print(f"Record: {file.get_record()}")

    arr[:,:,:] = rng.random(shape)
    file.fwrite(arr[:,:,:])

    print(f"{arr[:,:,:]}\n")

file.close()
```

## API
### `forbit.open()`
```python
file = forbit.open(filename, action, shape, kind, record, recstep, endian)
```
Open a Fortran direct-access unformatted binary file.

#### Parameters
- filename  
  `type=str`  
  File name of a no-header binary file.  
- action  
  `type=str`  
  File access mode.
  Accepted values are case-insensitive:
  - `"read"`
  - `"write"`
  - `"readwrite"`  

  The value is passed to the Fortran `OPEN` statement as the `ACTION` specifier.
- shape  
  `type=ndarray`  
  Other types of array such as `list` and `tuple` may be allowed.  
  Shape of one Fortran direct-access record as it should appear on the Python side.  
  Examples:
  - For a 1D record: `[nx]`
  - For a 2D record returned as (ny, nx): `[ny, nx]`
  - For a 3D record returned as (nz, ny, nx): `[nz, ny, nx]`  

  The shape is given in normal NumPy order.
  Internally, FORBIT reverses the dimensions when calling the Fortran routines so that a Python array shaped like `[nz, ny, nx]` corresponds to a Fortran array shaped like `(nx, ny, nz)` in the low-level read/write routine.  
  All dimensions must be positive integers.
  The number of dimensions must be between 1 and 6.
- kind  
  `type=int`  
  Floating-point precision of the binary file.  
  Accepted values:
  - 4: single precision, returned/written as `numpy.float32`
  - 8: double precision, returned/written as `numpy.float64`  

  This parameter describes the precision stored in the binary file.
  When writing, input arrays are converted to the selected precision before being passed to the Fortran write routine.
- record  
  `type=int`  
  Initial Fortran direct-access record number.
  Record numbers are 1-based, as in Fortran.
- recstep  
  `type=int`  
  Increment added to the internal record number after each `fread()` or `fwrite()` call.
  The value to increment record after every access.  
  Examples:
  - `recstep=1`: read/write consecutive records
  - `recstep=0`: keep using the same record number
  - `recstep=12`: jump by 12 records after each access  
- endian  
  `type=str`  
  Endian conversion mode passed to Fortran's `CONVERT` specifier.  
  Accepted values are case-insensitive:
  - `"little_endian"`
  - `"big_endian"`  

### `close()`
```python
file.close()
```
The file is also closed by the object's destructor, but explicit `close()` is recommended.

### `fread()`
```python
arr = file.fread()
```
Read the current record and return a NumPy array.
The returned array has the shape specified by `shape` and dtype determined by `kind`.
After reading, the internal record number is updated by `recstep`.

### `fwrite()`
```python
file.fwrite(arr)
```
The input array must have the same shape as the shape specified when opening the file.
Before writing, FORBIT converts the array to a C-contiguous NumPy array with dtype determined by `kind`.
After writing, the internal record number is updated by `recstep`.

### `get_record()`
```python
record = file.get_record()
```
Return the current internal record number.

### `reset_record(newRecord=None, increment=None)`
```python
file.reset_record(newRecord=10)
file.reset_record(increment=3)
```
Change the internal record number.  
If `newRecord` is provided, the internal record number is set to that value.
If `newRecord` is not provided and `increment` is provided, the internal record number is increased by `increment`.
If both arguments are provided, `newRecord` takes priority.

## File Format
FORBIT assumes that the file is a Fortran direct-access unformatted file with fixed-size records.  
For one record, the record length used internally is computed from shape and `kind`:
```python
recl = kind * product(shape)
```
This value is passed to the Fortran `OPEN` statement as `RECL`.  
The file is opened in Fortran with settings equivalent to:
```fortran
open(newunit=unit, file=..., action=..., form='unformatted', access='direct', recl=..., convert=...)
```

## Dimension Ordering
FORBIT's public Python API uses NumPy-style shapes.  
For example, if a Fortran program writes a 3D array as `(nx, ny, nz)`, the corresponding Python shape should normally be written as:
```python
shape = [nz, ny, nx]
```
This convention makes the returned NumPy array natural to index as:
```python
arr[0:nz,0:ny,0:nx]
```

## Precision and Dtype
| `kind` | File Precision | Returned dtype |
|--------|----------------|----------------|
| `4` | single precision (real32) | `numpy.float32` |
| `8` | double precision (real64) | `numpy.float64` |

Only floating-point data are supported by the public API.
Integer, complex, logical, character, and quadruple-precision records are not supported by the current implementation.

## Record Handling
The current record number is stored inside the `forbit` object.
Each call to `fread()` or `fwrite()` uses the current record number and then updates it as follows:
```python
record = record + recstep
```
Fortran direct-access record numbers are positive and 1-based.
The low-level Fortran routines stop with an error if a non-positive record number is used.

## Alternatives
### scipy.io.FortranFile
Sequential unformatted Fortran binary I/O with record markers.
FORBIT instead targets lightweight direct-access binary workflows.

### numpy.memmap
Low-level memory-mapped access to raw binary arrays.
FORBIT adds explicit record-oriented direct-access I/O.

### xgrads
xgrads provides higher-level GrADS/xarray workflows with metadata handling.
FORBIT instead focuses on lightweight direct-access binary I/O with explicit Fortran-style workflows for NumPy arrays.

