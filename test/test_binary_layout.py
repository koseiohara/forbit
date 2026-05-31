


import numpy as np
import pytest

import forbit

from conftest import KINDS, numpy_endian_dtype, sample_array


@pytest.mark.parametrize("kind", KINDS)
@pytest.mark.parametrize("endian", ["little_endian", "big_endian"])
def test_binary_bytes_match_requested_endian(binary_dir, kind, endian):
    shape = [4]
    filename = binary_dir / f"bytes_kind{kind}_{endian}.grd"

    data = sample_array(shape, kind, offset=1)

    writer = forbit.open(str(filename), "write", shape, kind, 1, 1, endian)
    writer.write(data)
    writer.close()

    expected = np.asarray(data, dtype=numpy_endian_dtype(kind, endian))
    expected_bytes = np.ascontiguousarray(expected).tobytes()

    assert filename.read_bytes() == expected_bytes


@pytest.mark.parametrize("kind", KINDS)
def test_recl_larger_than_array_size_separates_records(binary_dir, kind):
    shape = [2]
    filename = binary_dir / f"recl_stride_kind{kind}.grd"

    arr1 = sample_array(shape, kind, offset=0)
    arr2 = sample_array(shape, kind, offset=10)

    record_bytes = int(np.prod(shape)) * kind
    recl = record_bytes + 8

    writer = forbit.open(
        str(filename),
        "write",
        shape,
        kind,
        1,
        1,
        "little_endian",
        recl=recl,
    )
    writer.write(arr1)
    writer.write(arr2)
    writer.close()

    reader = forbit.open(
        str(filename),
        "read",
        shape,
        kind,
        1,
        1,
        "little_endian",
        recl=recl,
    )
    actual1 = reader.read()
    actual2 = reader.read()
    reader.close()

    np.testing.assert_array_equal(actual1, arr1)
    np.testing.assert_array_equal(actual2, arr2)


@pytest.mark.parametrize("kind", KINDS)
def test_recl_equal_to_array_size(binary_dir, kind):
    shape = [2, 3]
    filename = binary_dir / f"recl_exact_kind{kind}.grd"

    data = sample_array(shape, kind)
    recl = int(np.prod(shape)) * kind

    writer = forbit.open(
        str(filename),
        "write",
        shape,
        kind,
        1,
        1,
        "little_endian",
        recl=recl,
    )
    writer.write(data)
    writer.close()

    reader = forbit.open(
        str(filename),
        "read",
        shape,
        kind,
        1,
        1,
        "little_endian",
        recl=recl,
    )
    actual = reader.read()
    reader.close()

    np.testing.assert_array_equal(actual, data)


