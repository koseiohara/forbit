


import numpy as np
import pytest

import forbit

from conftest import KINDS, NDIMS, sample_array, shape_for_ndim


def test_invalid_filename_type():
    with pytest.raises(TypeError):
        forbit.open(123, "read", [2], 4, 1, 1, "little_endian")


def test_too_long_filename_is_rejected(binary_dir):
    filename = binary_dir / ("x" * 300)

    with pytest.raises(ValueError):
        forbit.open(str(filename), "write", [2], 4, 1, 1, "little_endian")


@pytest.mark.parametrize("action", ["append", "r", "w", "", None])
def test_invalid_action(binary_dir, action):
    filename = binary_dir / "invalid_action.grd"

    with pytest.raises((TypeError, ValueError)):
        forbit.open(str(filename), action, [2], 4, 1, 1, "little_endian")


@pytest.mark.parametrize("endian", ["foo", "little", "big", "", None])
def test_invalid_endian(binary_dir, endian):
    filename = binary_dir / "invalid_endian.grd"

    with pytest.raises((TypeError, ValueError)):
        forbit.open(str(filename), "write", [2], 4, 1, 1, endian)


@pytest.mark.parametrize("shape", [[], [[2, 3]], [2, 0], [2, -1], [1.5, 2], "abc"])
def test_invalid_shape(binary_dir, shape):
    filename = binary_dir / "invalid_shape.grd"

    with pytest.raises((TypeError, ValueError)):
        forbit.open(str(filename), "write", shape, 4, 1, 1, "little_endian")


@pytest.mark.parametrize("kind", [0, 2, 16, -4])
def test_invalid_kind(binary_dir, kind):
    filename = binary_dir / "invalid_kind.grd"

    with pytest.raises(ValueError):
        forbit.open(str(filename), "write", [2], kind, 1, 1, "little_endian")


def test_write_shape_mismatch(binary_dir):
    filename = binary_dir / "shape_mismatch.grd"

    file = forbit.open(str(filename), "write", [2, 3], 4, 1, 1, "little_endian")

    with pytest.raises(ValueError):
        file.write(np.zeros((3, 2, 2), dtype=np.float32))

    file.close()


def test_write_rejects_non_ndarray(binary_dir):
    filename = binary_dir / "non_ndarray.grd"

    file = forbit.open(str(filename), "write", [2], 4, 1, 1, "little_endian")

    with pytest.raises(TypeError):
        file.write([1.0, 2.0])

    file.close()


def test_write_rejects_non_float_dtype(binary_dir):
    filename = binary_dir / "non_float_dtype.grd"

    file = forbit.open(str(filename), "write", [2], 4, 1, 1, "little_endian")

    with pytest.raises(TypeError):
        file.write(np.array([1, 2], dtype=np.int32))

    file.close()


def test_recl_too_small_is_rejected(binary_dir):
    filename = binary_dir / "recl_too_small.grd"

    with pytest.raises(ValueError):
        forbit.open(str(filename), "write", [2, 3], 4, 1, 1, "little_endian", recl=4)


def test_open_missing_file_for_read_is_rejected(binary_dir):
    filename = binary_dir / "missing.grd"

    with pytest.raises(ValueError):
        forbit.open(str(filename), "read", [2], 4, 1, 1, "little_endian")


def test_exceed_record_raises_ioerror(binary_dir):
    filename = binary_dir / "exceed_record.grd"
    shape = [2, 3]

    file = forbit.open(str(filename), "write", shape, 4, 1, 1, "little_endian")
    file.write(np.zeros(shape, dtype=np.float32))
    file.close()

    file = forbit.open(str(filename), "read", shape, 4, 1, 1, "little_endian")

    np.testing.assert_array_equal(file.read(), np.zeros(shape, dtype=np.float32))

    with pytest.raises(IOError):
        file.read()

    file.close()


@pytest.mark.parametrize("record", [0, -1])
@pytest.mark.parametrize("kind", KINDS)
@pytest.mark.parametrize("ndim", NDIMS)
def test_read_non_positive_record_raises_ioerror(binary_dir, record, kind, ndim):
    filename = binary_dir / f"read_non_positive_record_kind{kind}_ndim{ndim}_{record}.grd"
    shape = shape_for_ndim(ndim)
    arr = sample_array(shape, kind)

    file = forbit.open(str(filename), "write", shape, kind, 1, 1, "little_endian")
    file.write(arr)
    file.close()

    file = forbit.open(str(filename), "read", shape, kind, record, 1, "little_endian")

    with pytest.raises(IOError):
        file.read()

    file.close()


@pytest.mark.parametrize("record", [0, -1])
@pytest.mark.parametrize("kind", KINDS)
@pytest.mark.parametrize("ndim", NDIMS)
def test_write_non_positive_record_raises_ioerror(binary_dir, record, kind, ndim):
    filename = binary_dir / f"write_non_positive_record_kind{kind}_ndim{ndim}_{record}.grd"
    shape = shape_for_ndim(ndim)
    arr = sample_array(shape, kind)

    file = forbit.open(str(filename), "write", shape, kind, record, 1, "little_endian")

    with pytest.raises(IOError):
        file.write(arr)

    file.close()


def test_reset_record_without_argument(binary_dir):
    filename = binary_dir / "reset_without_argument.grd"

    file = forbit.open(str(filename), "write", [2], 4, 1, 1, "little_endian")

    with pytest.raises(ValueError):
        file.reset_record()

    file.close()


def test_close_is_idempotent(binary_dir):
    filename = binary_dir / "close_idempotent.grd"

    file = forbit.open(str(filename), "write", [2], 4, 1, 1, "little_endian")
    file.close()
    file.close()


