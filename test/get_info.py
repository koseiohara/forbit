

def get_shape(ndim):
    shape = [None] * ndim
    for i in range(ndim):
        shape[i] = i + 2

    return shape


def get_filename(ndim, kind):
    raw_binary_file = f"binary/sample_kind{kind}_ndim{ndim:02}.grd"
    return raw_binary_file



