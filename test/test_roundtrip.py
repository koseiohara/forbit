

import numpy as np
import pytest

import forbit

from conftest import ENDIANS, KINDS, NDIMS, dtype_for_kind, sample_array, shape_for_ndim


@pytest.mark.parametrize("kind", KINDS)
@pytest.mark.parametrize("ndim", NDIMS)
@pytest.mark.parametrize("endian", ENDIANS)
def test_roundtrip_single_record(binary_dir, kind, ndim, endian):
    shape = shape_for_ndim(ndim)
    dtype = dtype_for_kind(kind)
    filename = binary_dir / f"roundtrip_kind{kind}_ndim{ndim}_{endian}.grd"

    expected = sample_array(shape, kind)

    writer = forbit.open(
        str(filename),
        action="write",
        shape=shape,
        kind=kind,
        record=1,
        recstep=1,
        endian=endian,
    )
    writer.write(expected)
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
    actual = reader.read()
    reader.close()

    assert actual.dtype == dtype
    assert list(actual.shape) == shape
    np.testing.assert_array_equal(actual, expected)



