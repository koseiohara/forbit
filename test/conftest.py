

from pathlib import Path

import numpy as np
import pytest

IKINDS = [2, 4, 8]
RKINDS = [4, 8]
NDIMS = [1, 2, 3, 4, 5, 7]
ENDIANS = ["little_endian", "big_endian", "native"]


def shape_for_ndim(ndim: int) -> list[int]:
    return list(range(2, ndim + 2))


def rdtype_for_kind(kind: int):
    if kind == 4:
        return np.float32
    if kind == 8:
        return np.float64
    raise ValueError(f"unsupported real kind: {kind}")


def idtype_for_kind(kind: int):
    if kind == 2:
        return np.int16
    if kind == 4:
        return np.int32
    if kind == 8:
        return np.int64
    raise ValueError(f"unsupported integer kind: {kind}")


def dtype_for_kind(kind: int, dtype: str = "real"):
    if dtype in ("real", "float"):
        return rdtype_for_kind(kind)
    if dtype in ("int", "integer"):
        return idtype_for_kind(kind)
    raise ValueError(f"unsupported dtype: {dtype}")


def numpy_endian_dtype(kind: int, endian: str, dtype: str = "real"):
    if dtype in ("real", "float"):
        if kind == 4:
            base = "f4"
        elif kind == 8:
            base = "f8"
        else:
            raise ValueError(f"unsupported real kind: {kind}")
    elif dtype in ("int", "integer"):
        if kind == 2:
            base = "i2"
        elif kind == 4:
            base = "i4"
        elif kind == 8:
            base = "i8"
        else:
            raise ValueError(f"unsupported integer kind: {kind}")
    else:
        raise ValueError(f"unsupported dtype: {dtype}")

    if endian == "little_endian":
        return np.dtype("<" + base)
    if endian == "big_endian":
        return np.dtype(">" + base)
    if endian == "native":
        return np.dtype("=" + base)
    raise ValueError(f"unsupported endian: {endian}")


def rsample_array(shape: list[int], kind: int, offset: float = 0.0):
    dtype = rdtype_for_kind(kind)
    size = int(np.prod(shape))
    data = np.arange(size, dtype=dtype).reshape(shape)
    return data + dtype(offset)


def isample_array(shape: list[int], kind: int, offset: int = 0):
    dtype = idtype_for_kind(kind)
    size = int(np.prod(shape))
    data = np.arange(size, dtype=dtype).reshape(shape)
    return data + dtype(offset)


def sample_array(shape: list[int], kind: int, offset=0, dtype: str = "real"):
    if dtype in ("real", "float"):
        return rsample_array(shape, kind, offset)
    if dtype in ("int", "integer"):
        return isample_array(shape, kind, offset)
    raise ValueError(f"unsupported dtype: {dtype}")


@pytest.fixture
def binary_dir(tmp_path: Path) -> Path:
    path = tmp_path / "binary"
    path.mkdir()
    return path


