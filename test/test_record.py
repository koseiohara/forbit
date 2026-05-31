

import numpy as np
import pytest

import forbit

from conftest import KINDS, NDIMS, sample_array, shape_for_ndim


@pytest.mark.parametrize("kind", KINDS)
@pytest.mark.parametrize("ndim", NDIMS)
def test_get_record_and_automatic_increment(binary_dir, kind, ndim):
    shape = shape_for_ndim(ndim)
    filename = binary_dir / f"record_increment_kind{kind}_ndim{ndim}.grd"
    arrays = [sample_array(shape, kind, offset=100 * i) for i in range(3)]

    writer = forbit.open(str(filename), "write", shape, kind, 1, 1, "little_endian")

    for expected_record, array in enumerate(arrays, start=1):
        assert writer.get_record() == expected_record
        writer.write(array)

    assert writer.get_record() == 4
    writer.close()

    reader = forbit.open(str(filename), "read", shape, kind, 1, 1, "little_endian")

    for expected_record, expected in enumerate(arrays, start=1):
        assert reader.get_record() == expected_record
        actual = reader.read()
        np.testing.assert_array_equal(actual, expected)

    assert reader.get_record() == 4
    reader.close()


@pytest.mark.parametrize("kind", KINDS)
def test_reset_record_with_new_record(binary_dir, kind):
    shape = [2, 3]
    filename = binary_dir / f"reset_new_record_kind{kind}.grd"
    arrays = [sample_array(shape, kind, offset=10 * i) for i in range(4)]

    writer = forbit.open(str(filename), "write", shape, kind, 1, 1, "little_endian")
    for array in arrays:
        writer.write(array)
    writer.close()

    reader = forbit.open(str(filename), "read", shape, kind, 1, 1, "little_endian")
    reader.reset_record(newRecord=3)

    assert reader.get_record() == 3
    np.testing.assert_array_equal(reader.read(), arrays[2])
    reader.close()


@pytest.mark.parametrize("kind", KINDS)
def test_reset_record_with_increment(binary_dir, kind):
    shape = [2, 3]
    filename = binary_dir / f"reset_increment_kind{kind}.grd"
    arrays = [sample_array(shape, kind, offset=10 * i) for i in range(4)]

    writer = forbit.open(str(filename), "write", shape, kind, 1, 1, "little_endian")
    for array in arrays:
        writer.write(array)
    writer.close()

    reader = forbit.open(str(filename), "read", shape, kind, 1, 1, "little_endian")
    reader.reset_record(increment=2)

    assert reader.get_record() == 3
    np.testing.assert_array_equal(reader.read(), arrays[2])
    reader.close()


@pytest.mark.parametrize("kind", KINDS)
def test_recstep_zero_reuses_same_record_by_spec(binary_dir, kind):
    shape = [2]
    filename = binary_dir / f"recstep_zero_kind{kind}.grd"

    first = sample_array(shape, kind, offset=0)
    second = sample_array(shape, kind, offset=10)

    writer = forbit.open(str(filename), "write", shape, kind, 1, 0, "little_endian")
    writer.write(first)
    writer.write(second)
    writer.close()

    reader = forbit.open(str(filename), "read", shape, kind, 1, 1, "little_endian")
    actual = reader.read()
    reader.close()

    np.testing.assert_array_equal(actual, second)


@pytest.mark.parametrize("kind", KINDS)
def test_negative_recstep_reads_backward_by_spec(binary_dir, kind):
    shape = [2]
    filename = binary_dir / f"negative_recstep_kind{kind}.grd"
    arrays = [sample_array(shape, kind, offset=10 * i) for i in range(3)]

    writer = forbit.open(str(filename), "write", shape, kind, 1, 1, "little_endian")
    for array in arrays:
        writer.write(array)
    writer.close()

    reader = forbit.open(str(filename), "read", shape, kind, 3, -1, "little_endian")

    np.testing.assert_array_equal(reader.read(), arrays[2])
    np.testing.assert_array_equal(reader.read(), arrays[1])
    np.testing.assert_array_equal(reader.read(), arrays[0])

    reader.close()


@pytest.mark.parametrize("kind", KINDS)
def test_sparse_record_write(binary_dir, kind):
    shape = [2]
    filename = binary_dir / f"sparse_record_kind{kind}.grd"
    expected = sample_array(shape, kind, offset=100)

    writer = forbit.open(str(filename), "write", shape, kind, 100, 1, "little_endian")
    writer.write(expected)
    writer.close()

    reader = forbit.open(str(filename), "read", shape, kind, 100, 1, "little_endian")
    actual = reader.read()
    reader.close()

    np.testing.assert_array_equal(actual, expected)



