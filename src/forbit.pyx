#cython: language_level=3

import  numpy as np
cimport numpy as np
from numpy cimport PyArray_DATA

cimport cython
from libc.string cimport strncpy

np.import_array()

cdef extern from "binio.h":
    void binio_fopen(      int*       unit   ,
                           int*       stat   ,
                     const char*      file   ,
                           int*       filelen,
                     const char*      action ,
                     const long long* recl   ,
                     const char*      endian );


    void binio_fclose(const int* unit);


    void binio_fread_sp(const int*   unit      ,
                        const long long* n     ,
                        const long long* record,
                              float* input_data,
                              int*   stat      );

    void binio_fread_dp(const int*    unit      ,
                        const long long* n      ,
                        const long long* record ,
                              double* input_data,
                              int*   stat       );

    void binio_fwrite_sp(const int*   unit       ,
                         const long long* n      ,
                         const long long* record ,
                               float* output_data,
                               int*   stat       );

    void binio_fwrite_dp(const int*    unit       ,
                         const long long* n       ,
                         const long long* record  ,
                               double* output_data,
                               int*   stat       );


# ctypedef fused real_t:
#     np.float32_t
#     np.float64_t


DEF ACTIONLEN_MAX = 15
DEF ENDIANLEN_MAX = 15


cdef class _ForbitCore:
    
    cdef object __file
    cdef char __action[ACTIONLEN_MAX+1]
    cdef char __endian[ENDIANLEN_MAX+1]
    cdef list __shape
    cdef int  __unit
    cdef int  __kind
    cdef int  __is_open
    cdef int  __ndim
    cdef long long __size
    cdef long long __record
    cdef long long __recstep
    # cdef object __order

    cdef public object read
    cdef public object write


    def __init__(self, filename, action, object shape, const int kind, const long long record, const long long recstep, endian, object recl=None):
        cdef np.ndarray shape_cp
        cdef bytes work_file
        cdef const char* c_file
        cdef long long recl_cp
        cdef long long arr_byte
        cdef int stat
        cdef int pos
        cdef int i
        cdef int filelen
        cdef int action_label   # 1=read, 0=readwrite, -1=write
        cdef int precision
        cdef int dispatch

        self.__is_open = 0

        if (isinstance(filename, str)):
            pos = filename.find('\0')
            if pos != -1:
                filename_c_view = filename[:pos]
            else:
                filename_c_view = filename

            if filename_c_view == "":
                raise ValueError("Invalid filename: filename is empty")

            self.__file = filename
            work_file   = filename.encode("utf-8")
            c_file      = work_file
            filelen     = len(work_file)
        else:
            raise TypeError("Invalid data type in the argument of forbit : filename")

        # if (len(filename) > FILELEN_MAX):
        #     raise ValueError("File name is too long " + filename)

        if (isinstance(action, str)):
            action = action.lower()
            if (action != "read" and action != "write" and action != "readwrite"):
                raise ValueError("Invalid string in the argument of forbit : action")

            if (action == "read"):
                action_label = 1
            elif (action == "write"):
                action_label = -1
            else:
                action_label = 0

            action = action.encode("utf-8")
        else:
            raise TypeError("Invalid data type in the argument of forbit : action")

        if (isinstance(endian, str)):
            endian = endian.lower()
            if (endian !="little_endian" and endian != "big_endian" and endian != "native"):
                raise ValueError("Invalid string in the argument of forbit : endian")
            endian = endian.encode("utf-8")
        else:
            raise TypeError("Invalid data type in the argument of forbit : endian")

        shape_raw = np.atleast_1d(np.array(shape))
        if (shape_raw.ndim != 1):
            raise ValueError("Invalid shape: shape must be a 1-dimensional sequence")

        if (not np.issubdtype(shape_raw.dtype, np.integer)):
            raise TypeError("Invalid Shape: all elements of shape must be integer value")

        shape_cp    = shape_raw.astype(np.intc)
        self.__ndim = shape_cp.size

        if (kind != 4 and kind != 8):
            raise ValueError("Invalid kind parameter")

        
        # strncpy(self.__file  , filename, FILELEN_MAX  +1)
        strncpy(self.__action, action  , ACTIONLEN_MAX+1)
        strncpy(self.__endian, endian  , ENDIANLEN_MAX+1)

        # arr_byte = <long long>kind
        self.__size  = 1
        self.__shape = [None] * self.__ndim
        for i in range(self.__ndim):
            self.__shape[i] = int(shape_cp[i])

            if (self.__shape[i] <= 0):
                raise ValueError("Invalid shape: negative value is included in the input")

            self.__size = self.__size * <long long>self.__shape[i]

        arr_byte = self.__size * <long long>kind

        if (recl is None):
            recl_cp = arr_byte
        else:
            recl_cp = <long long>recl
            if (arr_byte > recl_cp):
                raise ValueError(f'"recl" is too small: {recl_cp}. "recl" must be equal or greater than the total size of array ({arr_byte}byte)')

        # if (isinstance(order, str)):
        #     order = order.lower()
        #     if (order != 'c' and order != 'f'):
        #         raise ValueError(f"Invalid order is provided: {order}. 'order' must be 'c' or 'f'")
        # else:
        #     raise TypeError("Invalid data type in the argument of forbit : order")
        # self.__order = order

        # if (order == 'c'):
        # self.__shape = self.__shape[::-1]
        
        self.__kind    = kind
        self.__record  = <long long>record
        self.__recstep = <long long>recstep


        binio_fopen(&self.__unit ,
                    &stat        ,
                    c_file       ,
                    &filelen     ,
                    self.__action,
                    &recl_cp     ,
                    self.__endian)

        if (stat != 0):
            raise ValueError(f"Failed to open {filename}")

        self.__is_open = 1

        fread_list = [self.fread_sp ,
                      self.fread_dp ,
                      self.fread_err,]

        fwrite_list = [self.fwrite_sp ,
                       self.fwrite_dp ,
                       self.fwrite_err,]

        precision = kind >> 2
        # dispatch  = ((self.__ndim - 1) << 1) + precision - 1
        dispatch  = precision - 1

        if (action_label == 1):
            self.read  =  fread_list[dispatch]
            self.write = fwrite_list[-1]
        elif (action_label == -1):
            self.read  =  fread_list[-1]
            self.write = fwrite_list[dispatch]
        else:
            self.read  =  fread_list[dispatch]
            self.write = fwrite_list[dispatch]


    def __del__(self):
        self.close()


    def close(self):
        if (self.__is_open == 1):
            binio_fclose(&self.__unit)
            self.__unit    = -999999
            self.__is_open = 0


    def fread_sp(self):
        cdef np.ndarray[np.float32_t,ndim=1] result
        cdef int stat
        result = np.empty(self.__size, dtype=np.float32)

        # self.__negative_record()

        binio_fread_sp(&self.__unit                 ,
                       &self.__size                 ,
                       &self.__record               ,
                       <float*> PyArray_DATA(result),
                       &stat                        )

        self.__read_check(stat)
        self.__record = self.__record + self.__recstep

        return result.reshape(self.__shape)


    def fread_dp(self):
        cdef np.ndarray[np.float64_t,ndim=1] result
        cdef int stat
        result = np.empty(self.__size, dtype=np.float64)

        # self.__negative_record()

        binio_fread_dp(&self.__unit                  ,
                       &self.__size                  ,
                       &self.__record                ,
                       <double*> PyArray_DATA(result),
                       &stat                         )

        self.__read_check(stat)
        self.__record = self.__record + self.__recstep

        return result.reshape(self.__shape)


    def fread_err(self):
        raise PermissionError("read operation is not permitted because the file was opened with action='write'")
        

    def fwrite_sp(self, arr):
        cdef np.ndarray[np.float32_t,ndim=1] arr_cp
        cdef int stat

        if ((not isinstance(arr, np.ndarray)) or
            (arr.dtype != np.float32 and arr.dtype != np.float64)):
            raise TypeError("Invalid input type for forbit.write: Input must be a NumPy ndarray with dtype float32 or float64")

        arr_cp = np.ascontiguousarray(arr, dtype=np.float32).reshape(-1)

        if (arr_cp.size != self.__size):
            raise ValueError(f"Invalid array size for forbit.write: expected {self.__size}, got {arr_cp.size}")

        binio_fwrite_sp(&self.__unit                 ,
                        &self.__size                 ,
                        &self.__record               ,
                        <float*> PyArray_DATA(arr_cp),
                        &stat                         )

        self.__write_check(stat)
        self.__record = self.__record + self.__recstep


    def fwrite_dp(self, arr):
        cdef np.ndarray[np.float64_t,ndim=1] arr_cp
        cdef int stat

        if ((not isinstance(arr, np.ndarray)) or
            (arr.dtype != np.float32 and arr.dtype != np.float64)):
            raise TypeError("Invalid input type for forbit.write: Input must be a NumPy ndarray with dtype float32 or float64")

        arr_cp = np.ascontiguousarray(arr, dtype=np.float64).reshape(-1)

        if (arr_cp.size != self.__size):
            raise ValueError(f"Invalid array size for forbit.write: expected {self.__size}, got {arr_cp.size}")

        binio_fwrite_dp(&self.__unit                  ,
                        &self.__size                  ,
                        &self.__record                ,
                        <double*> PyArray_DATA(arr_cp),
                        &stat                          )

        self.__write_check(stat)
        self.__record = self.__record + self.__recstep


    def fwrite_err(self, arr):
        raise PermissionError("write operation is not permitted because the file was opened with action='read'")
        

    def get_record(self):
        return self.__record


    def reset_record(self, object newRecord=None, object increment=None):
        if (newRecord is not None):
            self.__record = <long long>newRecord
            return
        elif (increment is not None):
            self.__record = self.__record + <long long>increment
            return

        raise ValueError("In forbit.reset_record()\nAt least one of 'newRecord' or 'increment' must be provided")


    def __negative_record(self):
        if (self.__record > 0):
            return

        raise ValueError(f'Invalid record: {self.__record}. Current record is zero or a negative value')


    def __read_check(self, stat):
        if (stat == 0):
            return

        raise IOError(f'Failed to read binary file. Record: {self.__record}, Fortran IOSTAT: {stat}')


    def __write_check(self, stat):
        if (stat == 0):
            return

        raise IOError(f'Failed to write to a binary file. Record: {self.__record}, Fortran IOSTAT: {stat}')


# def open(filename, action, shape, kind, record, recstep, endian, recl=None):
#     return _ForbitCore(filename, action, shape, kind, record, recstep, endian, recl)

open   = _ForbitCore
forbit = _ForbitCore





