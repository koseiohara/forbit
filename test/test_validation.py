

import numpy as np
import pytest

import forbit

from conftest import ENDIANS, KINDS, NDIMS, dtype_for_kind, sample_array, shape_for_ndim

ndim_max = 6
def test_invalid_filename_type():
    with pytest.raises(TypeError):
        forbit.open(123, "read", [2], 4, 1, 1, "little_endian")


def test_invalid_action(binary_dir):
    filename = binary_dir / "invalid_action.grd"

    with pytest.raises(ValueError):
        forbit.open(str(filename), "append", [2], 4, 1, 1, "little_endian")


def test_invalid_endian(binary_dir):
    filename = binary_dir / "invalid_endian.grd"

    with pytest.raises(ValueError):
        forbit.open(str(filename), "write", [2], 4, 1, 1, "foo")


@pytest.mark.parametrize("shape", [[], [[2, 3]], [2, 0], [2, -1]])
def test_invalid_shape(binary_dir, shape):
    filename = binary_dir / "invalid_shape.grd"

    with pytest.raises((TypeError, ValueError)):
        forbit.open(str(filename), "write", shape, 4, 1, 1, "little_endian")

@pytest.mark.parametrize("record", [0, -1])
@pytest.mark.parametrize("kind"  , KINDS)
@pytest.mark.parametrize("ndim"  , NDIMS)
def test_invalid_record(binary_dir, record, kind, ndim):
    filename = binary_dir / "invalid_shape.grd"
    shape    = shape_for_ndim(ndim)
    arr      = sample_array(shape, kind, 1)
    fp = forbit.open(str(filename), 'write', shape, kind, record, 1, "little_endian")
    with pytest.raises(ValueError):
        fp.write(arr)
    fp.close()


def test_too_many_dimensions(binary_dir):
    filename = binary_dir / "too_many_dimensions.grd"

    with pytest.raises(ValueError):
        forbit.open(str(filename), "write", [2]*(ndim_max+1), 4, 1, 1, "little_endian")


def test_invalid_kind(binary_dir):
    filename = binary_dir / "invalid_kind.grd"

    with pytest.raises(ValueError):
        forbit.open(str(filename), "write", [2], 16, 1, 1, "little_endian")


def test_write_shape_mismatch(binary_dir):
    filename = binary_dir / "shape_mismatch.grd"

    file = forbit.open(str(filename), "write", [2, 3], 4, 1, 1, "little_endian")

    with pytest.raises(ValueError):
        file.write(np.zeros((3, 2), dtype=np.float32))

    file.close()


def test_open_error(binary_dir):
    filename = binary_dir / "open_error.grd"
    failfile = binary_dir / "open_error2.grd"
    shape = [2,3]

    file = forbit.open(str(filename), "write", shape, 4, 1, 1, "little_endian")
    file.write(np.zeros(shape, dtype=np.float32))
    file.close()

    with pytest.raises(ValueError):
        forbit.open(str(failfile), "read", shape, 4, 1, 1, "little_endian")


def test_reset_record_without_argument(binary_dir):
    filename = binary_dir / "reset_without_argument.grd"

    file = forbit.open(str(filename), "write", [2], 4, 1, 1, "little_endian")

    with pytest.raises(ValueError):
        file.reset_record()

    file.close()


