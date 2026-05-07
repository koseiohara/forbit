
from pathlib import Path
import time
import numpy as np
import forbit

out_dir    = "bin"
result_dir = "result"

Path(out_dir).mkdir(exist_ok=True)
Path(result_dir).mkdir(exist_ok=True)

nx = 300
ny = 150
nz =  50
nt = 100

numpy_contig_name  = f"{out_dir}/numpy_contig.grd"
numpy_skip_name    = f"{out_dir}/numpy_skip.grd"
forbit_contig_name = f"{out_dir}/forbit_contig.grd"
forbit_skip_name   = f"{out_dir}/forbit_skip.grd"

kind = 4
if (kind == 4):
    arr_dtype = np.float32
elif (kind == 8):
    arr_dtype = np.float64
else:
    raise ValueError("kind must be 4 or 8")

shape   = [nz,ny,nx]
recl    = kind * nx * ny * nz
recstep = 3

def test_fromfile_contig(filename):
    arr = sample_arr[...]

    fp = open(filename, 'rb')
    for t in range(nt):
        work_arr = np.fromfile(fp                         ,
                               dtype=arr_dtype            ,
                               count=nz*ny*nx             )
        arr[...] = work_arr.reshape(shape)

    fp.close()

def test_fromfile_skip(filename):
    arr = sample_arr[...]

    fp = open(filename, 'rb')
    record = 1
    for t in range(nt):
        fp.seek((record-1)*recl)
        work_arr = np.fromfile(fp              ,
                               dtype=arr_dtype ,
                               count=nz*ny*nx  )

        arr[...] = work_arr.reshape(shape)
        record = record + recstep

    fp.close()

def test_forbit_contig(filename):
    arr = sample_arr[...]

    record = 1
    fp = forbit.open(filename                 ,
                     action ='read'           ,
                     shape  =shape            ,
                     kind   =kind             ,
                     record =record           ,
                     recstep=1                ,
                     endian ='little_endian'  )

    for t in range(nt):
        arr[...] = fp.read()

    fp.close()

def test_forbit_skip(filename):
    arr = sample_arr[...]

    record = 1
    fp = forbit.open(filename                 ,
                     action ='read'           ,
                     shape  =shape            ,
                     kind   =kind             ,
                     record =record           ,
                     recstep=recstep          ,
                     endian ='little_endian'  )

    for t in range(nt):
        arr[...] = fp.read()

    fp.close()

for filename in [numpy_contig_name  ,
                 numpy_skip_name    ,
                 forbit_contig_name ,
                 forbit_skip_name   ]:

    if not Path(filename).exists():
        raise FileNotFoundError(f"{filename} does not exist. Run write benchmark first.")

ntest = 100
nwarm = 5
sample_arr = np.empty(shape, dtype=arr_dtype)
result = open(f"{result_dir}/read_benchmark_kind{kind}_recl{recl}_sparse{recstep}.txt", "a")

for n in range(nwarm):
    test_forbit_contig(forbit_contig_name)

t0 = time.perf_counter()
for n in range(ntest):
    test_forbit_contig(forbit_contig_name)
t1 = time.perf_counter()
elapse = (t1 - t0) / ntest
result.write(f"FORBIT CONTIGUOUS RECORD  : {elapse:.6f}s\n")

for n in range(nwarm):
    test_forbit_skip(forbit_skip_name)

t0 = time.perf_counter()
for n in range(ntest):
    test_forbit_skip(forbit_skip_name)
t1 = time.perf_counter()
elapse = (t1 - t0) / ntest
result.write(f"FORBIT SPARSE             : {elapse:.6f}s\n")

for n in range(nwarm):
    test_fromfile_contig(numpy_contig_name)

t0 = time.perf_counter()
for n in range(ntest):
    test_fromfile_contig(numpy_contig_name)
t1 = time.perf_counter()
elapse = (t1 - t0) / ntest
result.write(f"FROMFILE CONTIGUOUS RECORD: {elapse:.6f}s\n")

for n in range(nwarm):
    test_fromfile_skip(numpy_skip_name)

t0 = time.perf_counter()
for n in range(ntest):
    test_fromfile_skip(numpy_skip_name)
t1 = time.perf_counter()
elapse = (t1 - t0) / ntest
result.write(f"FROMFILE SPARSE           : {elapse:.6f}s\n")

result.write("\n")
result.close()



