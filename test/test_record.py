
import numpy as np
import pytest

import forbit

from conftest import KINDS, NDIMS, sample_array, shape_for_ndim


@pytest.mark.parametrize("kind", KINDS)
@pytest.mark.parametrize("ndim", NDIMS)
def test_multiple_records_and_record_increment(binary_dir, kind, ndim):
    shape = shape_for_ndim(ndim)
    filename = binary_dir / f"records_kind{kind}_ndim{ndim}.grd"

    arrays = [sample_array(shape, kind, offset=1000 * i) for i in range(5)]

    writer = forbit.open(
        str(filename),
        action="write",
        shape=shape,
        kind=kind,
        record=1,
        recstep=1,
        endian="little_endian",
    )

    for i, array in enumerate(arrays, start=1):
        assert writer.get_record() == i
        writer.write(array)

    assert writer.get_record() == 6
    writer.close()

    reader = forbit.open(
        str(filename),
        action="read",
        shape=shape,
        kind=kind,
        record=1,
        recstep=1,
        endian="little_endian",
    )

    for i, expected in enumerate(arrays, start=1):
        assert reader.get_record() == i
        actual = reader.read()
        np.testing.assert_array_equal(actual, expected)

    assert reader.get_record() == 6
    reader.close()


@pytest.mark.parametrize("kind", KINDS)
def test_reset_record_with_new_record(binary_dir, kind):
    shape = [2, 3]
    filename = binary_dir / f"reset_newrecord_kind{kind}.grd"

    arrays = [sample_array(shape, kind, offset=10 * i) for i in range(4)]

    writer = forbit.open(str(filename), "write", shape, kind, 1, 1, "little_endian")
    for array in arrays:
        writer.write(array)
    writer.close()

    reader = forbit.open(str(filename), "read", shape, kind, 1, 1, "little_endian")
    reader.reset_record(newRecord=3)

    assert reader.get_record() == 3
    actual = reader.read()
    reader.close()

    np.testing.assert_array_equal(actual, arrays[2])


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
    actual = reader.read()
    reader.close()

    np.testing.assert_array_equal(actual, arrays[2])



