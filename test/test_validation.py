

import numpy as np
import pytest

import forbit

from conftest import IKINDS, RKINDS, NDIMS, isample_array, rsample_array, sample_array, shape_for_ndim


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
def test_invalid_real_kind(binary_dir, kind):
    filename = binary_dir / "invalid_real_kind.grd"
    with pytest.raises(ValueError):
        forbit.open(str(filename), "write", [2], kind, 1, 1, "little_endian", dtype="real")


@pytest.mark.parametrize("kind", [0, 1, 16, -4])
def test_invalid_integer_kind(binary_dir, kind):
    filename = binary_dir / "invalid_integer_kind.grd"
    with pytest.raises(ValueError):
        forbit.open(str(filename), "write", [2], kind, 1, 1, "little_endian", dtype="integer")


@pytest.mark.parametrize("dtype", ["complex", "double", "i4", "", None])
def test_invalid_dtype(binary_dir, dtype):
    filename = binary_dir / "invalid_dtype.grd"
    with pytest.raises((TypeError, ValueError)):
        forbit.open(str(filename), "write", [2], 4, 1, 1, "little_endian", dtype=dtype)


def test_real_write_shape_mismatch(binary_dir):
    filename = binary_dir / "real_shape_mismatch.grd"
    file = forbit.open(str(filename), "write", [2, 3], 4, 1, 1, "little_endian", dtype="real")
    with pytest.raises(ValueError):
        file.write(np.zeros((3, 2, 2), dtype=np.float32))
    file.close()


def test_integer_write_shape_mismatch(binary_dir):
    filename = binary_dir / "integer_shape_mismatch.grd"
    file = forbit.open(str(filename), "write", [2, 3], 4, 1, 1, "little_endian", dtype="integer")
    with pytest.raises(ValueError):
        file.write(np.zeros((3, 2, 2), dtype=np.int32))
    file.close()


def test_real_write_rejects_non_ndarray(binary_dir):
    filename = binary_dir / "real_non_ndarray.grd"
    file = forbit.open(str(filename), "write", [2], 4, 1, 1, "little_endian", dtype="real")
    with pytest.raises(TypeError):
        file.write([1.0, 2.0])
    file.close()


def test_integer_write_rejects_non_ndarray(binary_dir):
    filename = binary_dir / "integer_non_ndarray.grd"
    file = forbit.open(str(filename), "write", [2], 4, 1, 1, "little_endian", dtype="integer")
    with pytest.raises(TypeError):
        file.write([1, 2])
    file.close()


def test_real_write_rejects_non_float_dtype(binary_dir):
    filename = binary_dir / "real_non_float_dtype.grd"
    file = forbit.open(str(filename), "write", [2], 4, 1, 1, "little_endian", dtype="real")
    with pytest.raises(TypeError):
        file.write(np.array([1, 2], dtype=np.int32))
    file.close()


def test_integer_write_rejects_non_integer_dtype(binary_dir):
    filename = binary_dir / "integer_non_integer_dtype.grd"
    file = forbit.open(str(filename), "write", [2], 4, 1, 1, "little_endian", dtype="integer")
    with pytest.raises(TypeError):
        file.write(np.array([1.0, 2.0], dtype=np.float32))
    file.close()


@pytest.mark.parametrize("kind", RKINDS)
def test_real_recl_too_small_is_rejected(binary_dir, kind):
    filename = binary_dir / f"real_recl_too_small_kind{kind}.grd"
    with pytest.raises(ValueError):
        forbit.open(str(filename), "write", [2, 3], kind, 1, 1, "little_endian", recl=kind, dtype="real")


@pytest.mark.parametrize("kind", IKINDS)
def test_integer_recl_too_small_is_rejected(binary_dir, kind):
    filename = binary_dir / f"integer_recl_too_small_kind{kind}.grd"
    with pytest.raises(ValueError):
        forbit.open(str(filename), "write", [2, 3], kind, 1, 1, "little_endian", recl=kind, dtype="integer")


def test_open_missing_file_for_read_is_rejected(binary_dir):
    filename = binary_dir / "missing.grd"
    with pytest.raises(ValueError):
        forbit.open(str(filename), "read", [2], 4, 1, 1, "little_endian")


def test_real_exceed_record_raises_ioerror(binary_dir):
    filename = binary_dir / "real_exceed_record.grd"
    shape = [2, 3]
    expected = np.zeros(shape, dtype=np.float32)

    file = forbit.open(str(filename), "write", shape, 4, 1, 1, "little_endian", dtype="real")
    file.write(expected)
    file.close()

    file = forbit.open(str(filename), "read", shape, 4, 1, 1, "little_endian", dtype="real")
    np.testing.assert_array_equal(file.read(), expected)
    with pytest.raises(IOError):
        file.read()
    file.close()


def test_integer_exceed_record_raises_ioerror(binary_dir):
    filename = binary_dir / "integer_exceed_record.grd"
    shape = [2, 3]
    expected = np.zeros(shape, dtype=np.int32)

    file = forbit.open(str(filename), "write", shape, 4, 1, 1, "little_endian", dtype="integer")
    file.write(expected)
    file.close()

    file = forbit.open(str(filename), "read", shape, 4, 1, 1, "little_endian", dtype="integer")
    np.testing.assert_array_equal(file.read(), expected)
    with pytest.raises(IOError):
        file.read()
    file.close()


@pytest.mark.parametrize("record", [0, -1])
@pytest.mark.parametrize("kind", RKINDS)
@pytest.mark.parametrize("ndim", NDIMS)
def test_real_read_non_positive_record_raises_ioerror(binary_dir, record, kind, ndim):
    filename = binary_dir / f"real_read_non_positive_record_kind{kind}_ndim{ndim}_{record}.grd"
    shape = shape_for_ndim(ndim)
    arr = rsample_array(shape, kind)

    file = forbit.open(str(filename), "write", shape, kind, 1, 1, "little_endian", dtype="real")
    file.write(arr)
    file.close()

    file = forbit.open(str(filename), "read", shape, kind, record, 1, "little_endian", dtype="real")
    with pytest.raises(IOError):
        file.read()
    file.close()


@pytest.mark.parametrize("record", [0, -1])
@pytest.mark.parametrize("kind", IKINDS)
@pytest.mark.parametrize("ndim", NDIMS)
def test_integer_read_non_positive_record_raises_ioerror(binary_dir, record, kind, ndim):
    filename = binary_dir / f"integer_read_non_positive_record_kind{kind}_ndim{ndim}_{record}.grd"
    shape = shape_for_ndim(ndim)
    arr = isample_array(shape, kind)

    file = forbit.open(str(filename), "write", shape, kind, 1, 1, "little_endian", dtype="integer")
    file.write(arr)
    file.close()

    file = forbit.open(str(filename), "read", shape, kind, record, 1, "little_endian", dtype="integer")
    with pytest.raises(IOError):
        file.read()
    file.close()


@pytest.mark.parametrize("record", [0, -1])
@pytest.mark.parametrize("kind", RKINDS)
@pytest.mark.parametrize("ndim", NDIMS)
def test_real_write_non_positive_record_raises_ioerror(binary_dir, record, kind, ndim):
    filename = binary_dir / f"real_write_non_positive_record_kind{kind}_ndim{ndim}_{record}.grd"
    shape = shape_for_ndim(ndim)
    arr = rsample_array(shape, kind)

    file = forbit.open(str(filename), "write", shape, kind, record, 1, "little_endian", dtype="real")
    with pytest.raises(IOError):
        file.write(arr)
    file.close()


@pytest.mark.parametrize("record", [0, -1])
@pytest.mark.parametrize("kind", IKINDS)
@pytest.mark.parametrize("ndim", NDIMS)
def test_integer_write_non_positive_record_raises_ioerror(binary_dir, record, kind, ndim):
    filename = binary_dir / f"integer_write_non_positive_record_kind{kind}_ndim{ndim}_{record}.grd"
    shape = shape_for_ndim(ndim)
    arr = isample_array(shape, kind)

    file = forbit.open(str(filename), "write", shape, kind, record, 1, "little_endian", dtype="integer")
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



