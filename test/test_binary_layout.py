

import numpy as np
import pytest

import forbit

from conftest import IKINDS, RKINDS, isample_array, numpy_endian_dtype, rsample_array


@pytest.mark.parametrize("kind", RKINDS)
@pytest.mark.parametrize("endian", ["little_endian", "big_endian"])
def test_real_binary_bytes_match_requested_endian(binary_dir, kind, endian):
    shape = [4]
    filename = binary_dir / f"real_bytes_kind{kind}_{endian}.grd"
    data = rsample_array(shape, kind, offset=1)

    writer = forbit.open(str(filename), "write", shape, kind, 1, 1, endian, dtype="real")
    writer.write(data)
    writer.close()

    expected = np.asarray(data, dtype=numpy_endian_dtype(kind, endian, dtype="real"))
    expected_bytes = np.ascontiguousarray(expected).tobytes()

    assert filename.read_bytes() == expected_bytes


@pytest.mark.parametrize("kind", IKINDS)
@pytest.mark.parametrize("endian", ["little_endian", "big_endian"])
def test_integer_binary_bytes_match_requested_endian(binary_dir, kind, endian):
    shape = [4]
    filename = binary_dir / f"integer_bytes_kind{kind}_{endian}.grd"
    data = isample_array(shape, kind, offset=1)

    writer = forbit.open(str(filename), "write", shape, kind, 1, 1, endian, dtype="integer")
    writer.write(data)
    writer.close()

    expected = np.asarray(data, dtype=numpy_endian_dtype(kind, endian, dtype="integer"))
    expected_bytes = np.ascontiguousarray(expected).tobytes()

    assert filename.read_bytes() == expected_bytes


@pytest.mark.parametrize("kind", RKINDS)
def test_real_recl_larger_than_array_size_separates_records(binary_dir, kind):
    shape = [2]
    filename = binary_dir / f"real_recl_stride_kind{kind}.grd"
    arr1 = rsample_array(shape, kind, offset=0)
    arr2 = rsample_array(shape, kind, offset=10)

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
        dtype="real",
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
        dtype="real",
    )
    actual1 = reader.read()
    actual2 = reader.read()
    reader.close()

    np.testing.assert_array_equal(actual1, arr1)
    np.testing.assert_array_equal(actual2, arr2)


@pytest.mark.parametrize("kind", IKINDS)
def test_integer_recl_larger_than_array_size_separates_records(binary_dir, kind):
    shape = [2]
    filename = binary_dir / f"integer_recl_stride_kind{kind}.grd"
    arr1 = isample_array(shape, kind, offset=0)
    arr2 = isample_array(shape, kind, offset=10)

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
        dtype="integer",
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
        dtype="integer",
    )
    actual1 = reader.read()
    actual2 = reader.read()
    reader.close()

    np.testing.assert_array_equal(actual1, arr1)
    np.testing.assert_array_equal(actual2, arr2)


@pytest.mark.parametrize("kind", RKINDS)
def test_real_recl_equal_to_array_size(binary_dir, kind):
    shape = [2, 3]
    filename = binary_dir / f"real_recl_exact_kind{kind}.grd"
    data = rsample_array(shape, kind)
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
        dtype="real",
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
        dtype="real",
    )
    actual = reader.read()
    reader.close()

    np.testing.assert_array_equal(actual, data)


@pytest.mark.parametrize("kind", IKINDS)
def test_integer_recl_equal_to_array_size(binary_dir, kind):
    shape = [2, 3]
    filename = binary_dir / f"integer_recl_exact_kind{kind}.grd"
    data = isample_array(shape, kind)
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
        dtype="integer",
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
        dtype="integer",
    )
    actual = reader.read()
    reader.close()

    np.testing.assert_array_equal(actual, data)



