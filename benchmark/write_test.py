
import sys
from pathlib import Path
import time
import filecmp
import numpy as np
import forbit

out_dir    = sys.argv[1]
result_dir = "result"
Path(out_dir).mkdir(exist_ok=True)
Path(result_dir).mkdir(exist_ok=True)

nx = 300
ny = 150
nz =  50
nt = 5000
numpy_contig_name  = f"{out_dir}/numpy_contig.grd"
numpy_skip_name    = f"{out_dir}/numpy_skip.grd"
forbit_contig_name = f"{out_dir}/forbit_contig.grd"
forbit_skip_name   = f"{out_dir}/forbit_skip.grd"

kind = 4
if (kind == 4):
    arr_dtype = np.float32
elif (kind == 8):
    arr_dtype = np.float64

recl    = kind * nx * ny * nz
recstep = 3

def gen_array():
    work_arr = np.arange(nz*ny*nx, dtype=arr_dtype)
    return work_arr.reshape(nz, ny, nx)


def test_tofile_contig(filename):
    arr = sample_arr[...]

    fp = open(filename, 'wb')
    for t in range(nt):
        arr.tofile(fp)

    fp.close()


def test_tofile_skip(filename):
    arr = sample_arr[...]

    fp = open(filename, 'wb')
    record = 1
    for t in range(nt):
        fp.seek((record-1)*recl)
        arr.tofile(fp)

        record = record + recstep

    fp.close()


def test_forbit_contig(filename):
    arr = sample_arr[...]

    record = 1
    fp = forbit.open(filename                 ,
                     action ='write'          ,
                     shape  =[nz,ny,nx]       ,
                     kind   =kind             ,
                     record =record           ,
                     recstep=1                ,
                     endian ='little_endian'  )
    for t in range(nt):
        fp.write(arr)

    fp.close()


def test_forbit_skip(filename):
    arr = sample_arr[...]

    record = 1
    fp = forbit.open(filename                 ,
                     action ='write'          ,
                     shape  =[nz,ny,nx]       ,
                     kind   =kind             ,
                     record =record           ,
                     recstep=recstep          ,
                     endian ='little_endian'  )
    for t in range(nt):
        fp.write(arr)

    fp.close()


ntest = 1
# nwarm = 5
sample_arr = gen_array()
result = open(f"{result_dir}/write_benchmark_kind{kind}_recl{recl}_sparse{recstep}.txt", "a")


t0 = time.perf_counter()
test_forbit_contig(forbit_contig_name)
t1 = time.perf_counter()
elapse = (t1 - t0) / (ntest*nt)
result.write(f"FORBIT CONTIGUOUS RECORD: {elapse:.6f}s\n")
print(f"FORBIT CONTIGUOUS RECORD: {elapse:.6f}s")


t0 = time.perf_counter()
test_forbit_skip(forbit_skip_name)
t1 = time.perf_counter()
elapse = (t1 - t0) / (ntest*nt)
result.write(f"FORBIT SPARSE           : {elapse:.6f}s\n")
print(f"FORBIT SPARSE           : {elapse:.6f}s")


t0 = time.perf_counter()
test_tofile_contig(numpy_contig_name)
t1 = time.perf_counter()
elapse = (t1 - t0) / (ntest*nt)
result.write(f"TOFILE CONTIGUOUS RECORD: {elapse:.6f}s\n")
print(f"TOFILE CONTIGUOUS RECORD: {elapse:.6f}s")


t0 = time.perf_counter()
test_tofile_skip(numpy_skip_name)
t1 = time.perf_counter()
elapse = (t1 - t0) / (ntest*nt)
result.write(f"TOFILE SPARSE           : {elapse:.6f}s\n")
print(f"TOFILE SPARSE           : {elapse:.6f}s")


# assert filecmp.cmp(numpy_contig_name, forbit_contig_name, shallow=False)
# assert filecmp.cmp(numpy_skip_name, forbit_skip_name, shallow=False)
# result.write("Binary equivalence check passed.\n\n")

result.write("\n")
result.close()


