
import os

import numpy as np
import pytest

import forbit

KINDS = [4,8]
SHAPES = [
        (10,),
        (3,4,),
        (3,4,5,),
        (3,4,5,6,),
        (3,4,5,6,7,),
        (3,4,5,6,7,8),
]

ENDIANS = ["little_endian", "big_endian"]

RECSTEPS = [1,4,7]

def get_dtype(kind):
    if (kind == 4):
        return np.float32
    elif (kind == 8):
        return np.float64
    
    raise ValueError("Invalid Kind Parameter")

def record_size(shape, kind):
    return int(np.prod(shape)) * kind

@pytest.mark.parametrize("kind", KINDS)
@pytest.mark.parametrize("shape", SHAPES)
@pytest.mark.parametrize("endian", ENDIANS)
@pytest.mark.parametrize("recstep", RECSTEPS)
def test_roundtrip(tmp_path, kind, shape, endian, recstep):
    dtype = get_dtype(kind)
    data1 = np.arange(0, np.prod(shape), dtype=dtype) + kind*1
    data2 = np.arange(0, np.prod(shape), dtype=dtype) + kind*2
    data1 = data1.reshape(shape)
    data2 = data2.reshape(shape)
    path = tmp_path / "sample.grd"
    f = forbit.open(
        str(path),
        action="write",
        shape=shape,
        kind=kind,
        record=1,
        recstep=recstep,
        endian=endian,
    )
    f.write(data1)
    f.write(data2)
    f.close()
    f = forbit.open(
        str(path),
        action="read",
        shape=shape,
        kind=kind,
        record=1,
        recstep=recstep,
        endian=endian,
    )
    out1 = f.read()
    out2 = f.read()
    f.close()
    np.testing.assert_array_equal(out1, data1)
    np.testing.assert_array_equal(out2, data2)
    expected_size = (1 + recstep) * record_size(shape, kind)
    actual_size = os.path.getsize(str(path))
    assert actual_size == expected_size



