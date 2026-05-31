
import numpy as np
import forbit


def test_filename_null(binary_dir):
    work = "filename_null.grd"
    ofilename = binary_dir / (work + "\0" + work)
    ifilename = binary_dir / work

    writer = forbit.open(str(ofilename), "write", [2], 4, 1, 1, "little_endian")
    writer.write(np.array([2,3], dtype=np.float32))
    writer.close()

    reader = forbit.open(str(ifilename), "read", [2], 4, 1, 1, "little_endian")

    reader.close()


