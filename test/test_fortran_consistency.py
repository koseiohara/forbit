


import numpy as np
import pytest

import forbit


NX = 3
NY = 4
NZ = 5
NR = 2
SHAPE = [NX, NY, NZ]
FORTRAN_BIN = "./binary/"


def expected_fortran_record(record: int, dtype):
    values = np.arange(1 + record, NX * NY * NZ + 1 + record, dtype=dtype)

    # Fortran の reshape(..., [nx, ny, nz]) と同じ logical 配列を、
    # forbit.read() の C-order reshape 仕様に合わせて表現する。
    return values.reshape(SHAPE)


@pytest.mark.parametrize(
    "filename,kind,dtype",
    [
        ("fortran_real32.grd", 4, np.float32),
        ("fortran_real64.grd", 8, np.float64),
    ],
)
def test_read_fortran_direct_access_binary(binary_dir, filename, kind, dtype):
    path = FORTRAN_BIN + filename

    reader = forbit.open(
        str(path),
        "read",
        SHAPE,
        kind,
        1,
        1,
        "little_endian",
    )

    for record in range(1, NR + 1):
        actual = reader.read()
        expected = expected_fortran_record(record, dtype)

        assert actual.dtype == dtype
        assert list(actual.shape) == SHAPE
        np.testing.assert_array_equal(actual, expected)

    reader.close()


@pytest.mark.parametrize(
    "filename,kind,dtype",
    [
        ("fortran_real32.grd", 4, np.float32),
        ("fortran_real64.grd", 8, np.float64),
    ],
)
def test_read_fortran_direct_access_binary_with_explicit_recl(binary_dir, filename, kind, dtype):
    path = FORTRAN_BIN + filename
    recl = kind * NX * NY * NZ

    reader = forbit.open(
        str(path),
        "read",
        SHAPE,
        kind,
        1,
        1,
        "little_endian",
        recl=recl,
    )

    for record in range(1, NR + 1):
        actual = reader.read()
        expected = expected_fortran_record(record, dtype)
        np.testing.assert_array_equal(actual, expected)

    reader.close()


@pytest.mark.parametrize(
    "filename,kind,dtype",
    [
        ("fortran_real32.grd", 4, np.float32),
        ("fortran_real64.grd", 8, np.float64),
    ],
)
def test_read_second_fortran_record_directly(binary_dir, filename, kind, dtype):
    path = FORTRAN_BIN + filename

    reader = forbit.open(
        str(path),
        "read",
        SHAPE,
        kind,
        2,
        1,
        "little_endian",
    )

    actual = reader.read()
    expected = expected_fortran_record(2, dtype)

    np.testing.assert_array_equal(actual, expected)

    reader.close()



