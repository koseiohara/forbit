

import numpy as np
import pytest

import forbit


def test_real_action_read_disallows_write(binary_dir):
    filename = binary_dir / "real_read_disallows_write.grd"

    writer = forbit.open(str(filename), "write", [2], 4, 1, 1, "little_endian", dtype="real")
    writer.write(np.array([1, 2], dtype=np.float32))
    writer.close()

    reader = forbit.open(str(filename), "read", [2], 4, 1, 1, "little_endian", dtype="real")
    with pytest.raises(PermissionError):
        reader.write(np.array([3, 4], dtype=np.float32))
    reader.close()


def test_integer_action_read_disallows_write(binary_dir):
    filename = binary_dir / "integer_read_disallows_write.grd"

    writer = forbit.open(str(filename), "write", [2], 4, 1, 1, "little_endian", dtype="integer")
    writer.write(np.array([1, 2], dtype=np.int32))
    writer.close()

    reader = forbit.open(str(filename), "read", [2], 4, 1, 1, "little_endian", dtype="integer")
    with pytest.raises(PermissionError):
        reader.write(np.array([3, 4], dtype=np.int32))
    reader.close()


def test_real_action_write_disallows_read(binary_dir):
    filename = binary_dir / "real_write_disallows_read.grd"
    writer = forbit.open(str(filename), "write", [2], 4, 1, 1, "little_endian", dtype="real")

    with pytest.raises(PermissionError):
        writer.read()
    writer.close()


def test_integer_action_write_disallows_read(binary_dir):
    filename = binary_dir / "integer_write_disallows_read.grd"
    writer = forbit.open(str(filename), "write", [2], 4, 1, 1, "little_endian", dtype="integer")

    with pytest.raises(PermissionError):
        writer.read()
    writer.close()


def test_real_action_readwrite_allows_read_and_write(binary_dir):
    filename = binary_dir / "real_readwrite_allows_both.grd"
    file = forbit.open(str(filename), "readwrite", [2], 4, 1, 1, "little_endian", dtype="real")
    expected = np.array([1, 2], dtype=np.float32)

    file.write(expected)
    file.reset_record(newRecord=1)
    actual = file.read()
    file.close()

    np.testing.assert_array_equal(actual, expected)


def test_integer_action_readwrite_allows_read_and_write(binary_dir):
    filename = binary_dir / "integer_readwrite_allows_both.grd"
    file = forbit.open(str(filename), "readwrite", [2], 4, 1, 1, "little_endian", dtype="integer")
    expected = np.array([1, 2], dtype=np.int32)

    file.write(expected)
    file.reset_record(newRecord=1)
    actual = file.read()
    file.close()

    np.testing.assert_array_equal(actual, expected)



