


import numpy as np
import pytest

import forbit


def test_action_read_disallows_write(binary_dir):
    filename = binary_dir / "read_disallows_write.grd"

    writer = forbit.open(str(filename), "write", [2], 4, 1, 1, "little_endian")
    writer.write(np.array([1, 2], dtype=np.float32))
    writer.close()

    reader = forbit.open(str(filename), "read", [2], 4, 1, 1, "little_endian")

    with pytest.raises(PermissionError):
        reader.write(np.array([3, 4], dtype=np.float32))

    reader.close()


def test_action_write_disallows_read(binary_dir):
    filename = binary_dir / "write_disallows_read.grd"

    writer = forbit.open(str(filename), "write", [2], 4, 1, 1, "little_endian")

    with pytest.raises(PermissionError):
        writer.read()

    writer.close()


def test_action_readwrite_allows_read_and_write(binary_dir):
    filename = binary_dir / "readwrite_allows_both.grd"

    file = forbit.open(str(filename), "readwrite", [2], 4, 1, 1, "little_endian")
    expected = np.array([1, 2], dtype=np.float32)

    file.write(expected)
    file.reset_record(newRecord=1)
    actual = file.read()
    file.close()

    np.testing.assert_array_equal(actual, expected)



