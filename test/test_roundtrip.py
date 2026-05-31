

import numpy as np
import pytest

import forbit

from conftest import (
    ENDIANS,
    IKINDS,
    RKINDS,
    NDIMS,
    idtype_for_kind,
    rdtype_for_kind,
    isample_array,
    rsample_array,
    shape_for_ndim,
)

NRECORDS = 4


@pytest.mark.parametrize("kind", RKINDS)
@pytest.mark.parametrize("ndim", NDIMS)
@pytest.mark.parametrize("endian", ENDIANS)
def test_real_roundtrip_multiple_records_all_supported_ndims(binary_dir, kind, ndim, endian):
    shape = shape_for_ndim(ndim)
    dtype = rdtype_for_kind(kind)
    filename = binary_dir / f"real_roundtrip_kind{kind}_ndim{ndim}_{endian}.grd"
    arrays = [rsample_array(shape, kind, offset=1000 * i) for i in range(NRECORDS)]

    writer = forbit.open(
        str(filename),
        action="write",
        shape=shape,
        kind=kind,
        record=1,
        recstep=1,
        endian=endian,
        dtype="real",
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
        dtype="real",
    )
    for expected in arrays:
        actual = reader.read()
        assert actual.dtype == dtype
        assert list(actual.shape) == shape
        np.testing.assert_array_equal(actual, expected)
    reader.close()


@pytest.mark.parametrize("kind", IKINDS)
@pytest.mark.parametrize("ndim", NDIMS)
@pytest.mark.parametrize("endian", ENDIANS)
def test_integer_roundtrip_multiple_records_all_supported_ndims(binary_dir, kind, ndim, endian):
    shape = shape_for_ndim(ndim)
    dtype = idtype_for_kind(kind)
    filename = binary_dir / f"integer_roundtrip_kind{kind}_ndim{ndim}_{endian}.grd"
    arrays = [isample_array(shape, kind, offset=1000 * i) for i in range(NRECORDS)]

    writer = forbit.open(
        str(filename),
        action="write",
        shape=shape,
        kind=kind,
        record=1,
        recstep=1,
        endian=endian,
        dtype="integer",
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
        dtype="integer",
    )
    for expected in arrays:
        actual = reader.read()
        assert actual.dtype == dtype
        assert list(actual.shape) == shape
        np.testing.assert_array_equal(actual, expected)
    reader.close()


@pytest.mark.parametrize("kind", RKINDS)
@pytest.mark.parametrize("endian", ENDIANS)
def test_real_roundtrip_non_contiguous_input(binary_dir, kind, endian):
    filename = binary_dir / f"real_non_contiguous_kind{kind}_{endian}.grd"
    dtype = rdtype_for_kind(kind)
    base = np.arange(60, dtype=dtype).reshape(5, 12)
    expected = base[:, ::2]
    assert not expected.flags.c_contiguous

    writer = forbit.open(str(filename), "write", list(expected.shape), kind, 1, 1, endian, dtype="real")
    writer.write(expected)
    writer.close()

    reader = forbit.open(str(filename), "read", list(expected.shape), kind, 1, 1, endian, dtype="real")
    actual = reader.read()
    reader.close()

    np.testing.assert_array_equal(actual, expected)


@pytest.mark.parametrize("kind", IKINDS)
@pytest.mark.parametrize("endian", ENDIANS)
def test_integer_roundtrip_non_contiguous_input(binary_dir, kind, endian):
    filename = binary_dir / f"integer_non_contiguous_kind{kind}_{endian}.grd"
    dtype = idtype_for_kind(kind)
    base = np.arange(60, dtype=dtype).reshape(5, 12)
    expected = base[:, ::2]
    assert not expected.flags.c_contiguous

    writer = forbit.open(str(filename), "write", list(expected.shape), kind, 1, 1, endian, dtype="integer")
    writer.write(expected)
    writer.close()

    reader = forbit.open(str(filename), "read", list(expected.shape), kind, 1, 1, endian, dtype="integer")
    actual = reader.read()
    reader.close()

    np.testing.assert_array_equal(actual, expected)


@pytest.mark.parametrize("kind", RKINDS)
@pytest.mark.parametrize("endian", ENDIANS)
def test_real_roundtrip_fortran_order_input(binary_dir, kind, endian):
    filename = binary_dir / f"real_fortran_order_kind{kind}_{endian}.grd"
    expected = np.asfortranarray(rsample_array([2, 3, 4], kind))
    assert expected.flags.f_contiguous

    writer = forbit.open(str(filename), "write", [2, 3, 4], kind, 1, 1, endian, dtype="real")
    writer.write(expected)
    writer.close()

    reader = forbit.open(str(filename), "read", [2, 3, 4], kind, 1, 1, endian, dtype="real")
    actual = reader.read()
    reader.close()

    np.testing.assert_array_equal(actual, expected)


@pytest.mark.parametrize("kind", IKINDS)
@pytest.mark.parametrize("endian", ENDIANS)
def test_integer_roundtrip_fortran_order_input(binary_dir, kind, endian):
    filename = binary_dir / f"integer_fortran_order_kind{kind}_{endian}.grd"
    expected = np.asfortranarray(isample_array([2, 3, 4], kind))
    assert expected.flags.f_contiguous

    writer = forbit.open(str(filename), "write", [2, 3, 4], kind, 1, 1, endian, dtype="integer")
    writer.write(expected)
    writer.close()

    reader = forbit.open(str(filename), "read", [2, 3, 4], kind, 1, 1, endian, dtype="integer")
    actual = reader.read()
    reader.close()

    np.testing.assert_array_equal(actual, expected)



