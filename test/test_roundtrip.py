

import numpy as np
import pytest

import forbit

from conftest import ENDIANS, KINDS, NDIMS, dtype_for_kind, sample_array, shape_for_ndim


NRECORDS = 4


@pytest.mark.parametrize("kind", KINDS)
@pytest.mark.parametrize("ndim", NDIMS)
@pytest.mark.parametrize("endian", ENDIANS)
def test_roundtrip_multiple_records_all_supported_ndims(binary_dir, kind, ndim, endian):
    shape = shape_for_ndim(ndim)
    dtype = dtype_for_kind(kind)
    filename = binary_dir / f"roundtrip_kind{kind}_ndim{ndim}_{endian}.grd"

    arrays = [sample_array(shape, kind, offset=1000 * i) for i in range(NRECORDS)]

    writer = forbit.open(
        str(filename),
        action="write",
        shape=shape,
        kind=kind,
        record=1,
        recstep=1,
        endian=endian,
    )
    for array in arrays:
        writer.write(array)
    writer.close()

    reader = forbit.open(
        str(filename),
        action="read",
        shape=shape,
        kind=kind,
        record=1,
        recstep=1,
        endian=endian,
    )
    for expected in arrays:
        actual = reader.read()
        assert actual.dtype == dtype
        assert list(actual.shape) == shape
        np.testing.assert_array_equal(actual, expected)
    reader.close()


@pytest.mark.parametrize("kind", KINDS)
@pytest.mark.parametrize("endian", ENDIANS)
def test_roundtrip_non_contiguous_input(binary_dir, kind, endian):
    filename = binary_dir / f"non_contiguous_kind{kind}_{endian}.grd"
    dtype = dtype_for_kind(kind)

    base = np.arange(60, dtype=dtype).reshape(5, 12)
    expected = base[:, ::2]

    assert not expected.flags.c_contiguous

    writer = forbit.open(str(filename), "write", list(expected.shape), kind, 1, 1, endian)
    writer.write(expected)
    writer.close()

    reader = forbit.open(str(filename), "read", list(expected.shape), kind, 1, 1, endian)
    actual = reader.read()
    reader.close()

    np.testing.assert_array_equal(actual, expected)


@pytest.mark.parametrize("kind", KINDS)
@pytest.mark.parametrize("endian", ENDIANS)
def test_roundtrip_fortran_order_input(binary_dir, kind, endian):
    filename = binary_dir / f"fortran_order_kind{kind}_{endian}.grd"

    expected = np.asfortranarray(sample_array([2, 3, 4], kind))
    assert expected.flags.f_contiguous

    writer = forbit.open(str(filename), "write", [2, 3, 4], kind, 1, 1, endian)
    writer.write(expected)
    writer.close()

    reader = forbit.open(str(filename), "read", [2, 3, 4], kind, 1, 1, endian)
    actual = reader.read()
    reader.close()

    np.testing.assert_array_equal(actual, expected)



