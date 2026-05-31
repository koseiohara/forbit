

import numpy as np

import forbit


def test_real_filename_null(binary_dir):
    work = "real_filename_null.grd"
    ofilename = binary_dir / (work + "\0" + work)
    ifilename = binary_dir / work

    writer = forbit.open(str(ofilename), "write", [2], 4, 1, 1, "little_endian", dtype="real")
    writer.write(np.array([2, 3], dtype=np.float32))
    writer.close()

    reader = forbit.open(str(ifilename), "read", [2], 4, 1, 1, "little_endian", dtype="real")
    reader.close()


def test_integer_filename_null(binary_dir):
    work = "integer_filename_null.grd"
    ofilename = binary_dir / (work + "\0" + work)
    ifilename = binary_dir / work

    writer = forbit.open(str(ofilename), "write", [2], 4, 1, 1, "little_endian", dtype="integer")
    writer.write(np.array([2, 3], dtype=np.int32))
    writer.close()

    reader = forbit.open(str(ifilename), "read", [2], 4, 1, 1, "little_endian", dtype="integer")
    reader.close()


