

from pathlib import Path

import numpy as np
import pytest


IKINDS = [2, 4, 8]
RKINDS = [4, 8]
NDIMS = [1, 2, 3, 4, 5, 10]
ENDIANS = ["little_endian", "big_endian", "native"]


def shape_for_ndim(ndim: int) -> list[int]:
    return list(range(2, ndim + 2))


def dtype_for_kind(kind: int):
    if kind == 4:
        return np.float32
    if kind == 8:
        return np.float64
    raise ValueError(f"unsupported kind: {kind}")


def numpy_endian_dtype(kind: int, endian: str):
    if kind == 4:
        base = "f4"
    elif kind == 8:
        base = "f8"
    else:
        raise ValueError(f"unsupported kind: {kind}")

    if endian == "little_endian":
        return np.dtype("<" + base)
    if endian == "big_endian":
        return np.dtype(">" + base)
    if endian == "native":
        return np.dtype("=" + base)

    raise ValueError(f"unsupported endian: {endian}")


def sample_array(shape: list[int], kind: int, offset: float = 0.0):
    dtype = dtype_for_kind(kind)
    size = int(np.prod(shape))
    data = np.arange(size, dtype=dtype).reshape(shape)
    return data + dtype(offset)


@pytest.fixture
def binary_dir(tmp_path: Path) -> Path:
    path = tmp_path / "binary"
    path.mkdir()
    return path



