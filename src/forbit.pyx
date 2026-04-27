#cython: language_level=3

import  numpy as np
cimport numpy as np
from numpy cimport PyArray_DATA

cimport cython
from libc.string cimport strncpy

cdef extern from "binio.h":
    void binio_fopen(      int*       unit  ,
                     const char*      file  ,
                     const char*      action,
                     const long long* recl  ,
                     const char*      endian );


    void binio_fclose(const int* unit);


    void binio_fread_sp1(const int*   unit      ,
                         const int*   n1        ,
                         const long long* record,
                               float* input_data);

    void binio_fread_dp1(const int*    unit      ,
                         const int*    n1        ,
                         const long long* record ,
                               double* input_data);

    void binio_fread_sp2(const int*   unit      ,
                         const int*   n1        ,
                         const int*   n2        ,
                         const long long* record,
                               float* input_data);

    void binio_fread_dp2(const int*    unit      ,
                         const int*    n1        ,
                         const int*    n2        ,
                         const long long* record ,
                               double* input_data);

    void binio_fread_sp3(const int*   unit      ,
                         const int*   n1        ,
                         const int*   n2        ,
                         const int*   n3        ,
                         const long long* record,
                               float* input_data);

    void binio_fread_dp3(const int*    unit      ,
                         const int*    n1        ,
                         const int*    n2        ,
                         const int*    n3        ,
                         const long long* record ,
                               double* input_data);

    void binio_fread_sp4(const int*   unit      ,
                         const int*   n1        ,
                         const int*   n2        ,
                         const int*   n3        ,
                         const int*   n4        ,
                         const long long* record,
                               float* input_data);

    void binio_fread_dp4(const int*    unit      ,
                         const int*    n1        ,
                         const int*    n2        ,
                         const int*    n3        ,
                         const int*    n4        ,
                         const long long* record ,
                               double* input_data);

    void binio_fread_sp5(const int*   unit      ,
                         const int*   n1        ,
                         const int*   n2        ,
                         const int*   n3        ,
                         const int*   n4        ,
                         const int*   n5        ,
                         const long long* record,
                               float* input_data);

    void binio_fread_dp5(const int*    unit      ,
                         const int*    n1        ,
                         const int*    n2        ,
                         const int*    n3        ,
                         const int*    n4        ,
                         const int*    n5        ,
                         const long long* record ,
                               double* input_data);

    void binio_fread_sp6(const int*   unit      ,
                         const int*   n1        ,
                         const int*   n2        ,
                         const int*   n3        ,
                         const int*   n4        ,
                         const int*   n5        ,
                         const int*   n6        ,
                         const long long* record,
                               float* input_data);

    void binio_fread_dp6(const int*    unit      ,
                         const int*    n1        ,
                         const int*    n2        ,
                         const int*    n3        ,
                         const int*    n4        ,
                         const int*    n5        ,
                         const int*    n6        ,
                         const long long* record ,
                               double* input_data);

    void binio_fwrite_sp1(const int*   unit       ,
                          const int*   n1         ,
                          const long long* record ,
                                float* output_data);

    void binio_fwrite_dp1(const int*    unit       ,
                          const int*    n1         ,
                          const long long* record  ,
                                double* output_data);

    void binio_fwrite_sp2(const int*   unit       ,
                          const int*   n1         ,
                          const int*   n2         ,
                          const long long* record ,
                                float* output_data);

    void binio_fwrite_dp2(const int*    unit       ,
                          const int*    n1         ,
                          const int*    n2         ,
                          const long long* record  ,
                                double* output_data);

    void binio_fwrite_sp3(const int*   unit       ,
                          const int*   n1         ,
                          const int*   n2         ,
                          const int*   n3         ,
                          const long long* record ,
                                float* output_data);

    void binio_fwrite_dp3(const int*    unit       ,
                          const int*    n1         ,
                          const int*    n2         ,
                          const int*    n3         ,
                          const long long* record  ,
                                double* output_data);

    void binio_fwrite_sp4(const int*   unit       ,
                          const int*   n1         ,
                          const int*   n2         ,
                          const int*   n3         ,
                          const int*   n4         ,
                          const long long* record ,
                                float* output_data);

    void binio_fwrite_dp4(const int*    unit       ,
                          const int*    n1         ,
                          const int*    n2         ,
                          const int*    n3         ,
                          const int*    n4         ,
                          const long long* record  ,
                                double* output_data);

    void binio_fwrite_sp5(const int*   unit       ,
                          const int*   n1         ,
                          const int*   n2         ,
                          const int*   n3         ,
                          const int*   n4         ,
                          const int*   n5         ,
                          const long long* record ,
                                float* output_data);

    void binio_fwrite_dp5(const int*    unit       ,
                          const int*    n1         ,
                          const int*    n2         ,
                          const int*    n3         ,
                          const int*    n4         ,
                          const int*    n5         ,
                          const long long* record  ,
                                double* output_data);

    void binio_fwrite_sp6(const int*   unit        ,
                          const int*   n1          ,
                          const int*   n2          ,
                          const int*   n3          ,
                          const int*   n4          ,
                          const int*   n5          ,
                          const int*   n6          ,
                          const long long* record  ,
                                float* output_data);

    void binio_fwrite_dp6(const int*    unit       ,
                          const int*    n1         ,
                          const int*    n2         ,
                          const int*    n3         ,
                          const int*    n4         ,
                          const int*    n5         ,
                          const int*    n6         ,
                          const long long* record  ,
                                double* output_data);



ctypedef fused real_t:
    np.float32_t
    np.float64_t


DEF FILELEN_MAX   = 255
DEF ACTIONLEN_MAX = 15
DEF ENDIANLEN_MAX = 15
DEF DIM_MAX       = 6


cdef class forbit:
    
    cdef char __file[FILELEN_MAX+1]
    cdef char __action[ACTIONLEN_MAX+1]
    cdef char __endian[ENDIANLEN_MAX+1]
    cdef int  __unit
    cdef int  __shape[DIM_MAX]
    cdef int  __kind
    cdef long long __record
    cdef long long __recstep
    cdef np.ndarray __work

    cdef public object fread
    cdef public object fwrite


    def __init__(self, filename, action, object shape, const int kind, const int record, const int recstep, endian):
        cdef np.ndarray shape_cp
        cdef long long recl
        cdef int shape_size
        cdef int i
        cdef int precision


        if (len(filename) > FILELEN_MAX):
            raise ValueError("File name is too long " + filename)

        if (isinstance(filename, str)):
            filename = filename.encode("utf-8")
        else:
            raise TypeError("Invalid data type in the argument of forbit : filename")

        if (isinstance(action, str)):
            action = action.lower()
            if (action != "read" and action != "write" and action != "readwrite"):
                raise ValueError("Invalid string in the argument of forbit : action")
            action = action.encode("utf-8")
        else:
            raise TypeError("Invalid data type in the argument of forbit : action")

        if (isinstance(endian, str)):
            endian = endian.lower()
            if (endian !="little_endian" and endian != "big_endian"):
                raise ValueError("Invalid string in the argument of forbit : endian")
            endian = endian.encode("utf-8")
        else:
            raise TypeError("Invalid data type in the argument of forbit : endian")

        shape_cp   = np.array(shape, dtype=np.intc)
        shape_size = shape_cp.size
        #shape_cp   = shape_cp[::-1]

        if (shape_size > DIM_MAX or shape_size < 1):
            raise ValueError("Invalid number of dimensions")

        if (kind != 4 and kind != 8):
            raise ValueError("Invalid kind parameter")

        
        strncpy(self.__file  , filename, FILELEN_MAX  +1)
        strncpy(self.__action, action  , ACTIONLEN_MAX+1)
        strncpy(self.__endian, endian  , ENDIANLEN_MAX+1)

        recl = <long long>kind
        for i in range(shape_size):
            self.__shape[i] = int(shape_cp[i])
            if (self.__shape[i] <= 0):
                raise ValueError("Invalid shape: negative value is included in the input")
            recl = recl*<long long>self.__shape[i]

        if (action == b"read" or action == b"readwrite"):
            if (kind == 4):
                self.__work = np.empty(shape_cp, dtype=np.float32)
            elif (kind == 8):
                self.__work = np.empty(shape_cp, dtype=np.float64)
        
        self.__kind    = kind
        self.__record  = <long long>record
        self.__recstep = <long long>recstep


        binio_fopen(&self.__unit ,
                    self.__file  ,
                    self.__action,
                    &recl        ,
                    self.__endian)

        fread_list = [self.fread_sp1,
                      self.fread_dp1,
                      self.fread_sp2,
                      self.fread_dp2,
                      self.fread_sp3,
                      self.fread_dp3,
                      self.fread_sp4,
                      self.fread_dp4,
                      self.fread_sp5,
                      self.fread_dp5]

        fwrite_list = [self.fwrite_sp1,
                       self.fwrite_dp1,
                       self.fwrite_sp2,
                       self.fwrite_dp2,
                       self.fwrite_sp3,
                       self.fwrite_dp3,
                       self.fwrite_sp4,
                       self.fwrite_dp4,
                       self.fwrite_sp5,
                       self.fwrite_dp5]

        precision = kind >> 2
        self.fread  =  fread_list[((shape_size-1)<<1)+precision-1]
        self.fwrite = fwrite_list[((shape_size-1)<<1)+precision-1]


    def __del__(self):
        self.close()


    def close(self):
        binio_fclose(&self.__unit)
        self.__unit = -999999


    def fread_sp1(self):
        # cdef np.ndarray[np.float32_t,ndim=1] result
        # result = np.empty(self.__shape[0], dtype=np.float32)

        binio_fread_sp1(&self.__unit                      ,
                        &self.__shape[0]                  ,
                        &self.__record                    ,
                        <float*> PyArray_DATA(self.__work))

        self.__record = self.__record + self.__recstep

        return self.__work


    def fread_dp1(self):
        # cdef np.ndarray[np.float64_t,ndim=1] result
        # result = np.empty(self.__shape[0], dtype=np.float64)

        binio_fread_dp1(&self.__unit                       ,
                        &self.__shape[0]                   ,
                        &self.__record                     ,
                        <double*> PyArray_DATA(self.__work))

        self.__record = self.__record + self.__recstep

        return self.__work
        

    def fread_sp2(self):
        # cdef np.ndarray[np.float32_t,ndim=2] result
        # result = np.empty((self.__shape[0],self.__shape[1]), dtype=np.float32)

        binio_fread_sp2(&self.__unit                      ,
                        &self.__shape[1]                  ,
                        &self.__shape[0]                  ,
                        &self.__record                    ,
                        <float*> PyArray_DATA(self.__work))

        self.__record = self.__record + self.__recstep

        return self.__work


    def fread_dp2(self):
        # cdef np.ndarray[np.float64_t,ndim=2] result
        # result = np.empty((self.__shape[0],self.__shape[1]), dtype=np.float64)

        binio_fread_dp2(&self.__unit                       ,
                        &self.__shape[1]                   ,
                        &self.__shape[0]                   ,
                        &self.__record                     ,
                        <double*> PyArray_DATA(self.__work))

        self.__record = self.__record + self.__recstep

        return self.__work


    def fread_sp3(self):
        # cdef np.ndarray[np.float32_t,ndim=3] result
        # result = np.empty((self.__shape[0],self.__shape[1],self.__shape[2]), dtype=np.float32)

        binio_fread_sp3(&self.__unit                      ,
                        &self.__shape[2]                  ,
                        &self.__shape[1]                  ,
                        &self.__shape[0]                  ,
                        &self.__record                    ,
                        <float*> PyArray_DATA(self.__work))

        self.__record = self.__record + self.__recstep

        return self.__work


    def fread_dp3(self):
        # cdef np.ndarray[np.float64_t,ndim=3] result
        # result = np.empty((self.__shape[0],self.__shape[1],self.__shape[2]), dtype=np.float64)

        binio_fread_dp3(&self.__unit                       ,
                        &self.__shape[2]                   ,
                        &self.__shape[1]                   ,
                        &self.__shape[0]                   ,
                        &self.__record                     ,
                        <double*> PyArray_DATA(self.__work))

        self.__record = self.__record + self.__recstep

        return self.__work


    def fread_sp4(self):
        # cdef np.ndarray[np.float32_t,ndim=3] result
        # result = np.empty((self.__shape[0],self.__shape[1],self.__shape[2]), dtype=np.float32)

        binio_fread_sp4(&self.__unit                      ,
                        &self.__shape[3]                  ,
                        &self.__shape[2]                  ,
                        &self.__shape[1]                  ,
                        &self.__shape[0]                  ,
                        &self.__record                    ,
                        <float*> PyArray_DATA(self.__work))

        self.__record = self.__record + self.__recstep

        return self.__work


    def fread_dp4(self):
        # cdef np.ndarray[np.float64_t,ndim=3] result
        # result = np.empty((self.__shape[0],self.__shape[1],self.__shape[2]), dtype=np.float64)

        binio_fread_dp4(&self.__unit                       ,
                        &self.__shape[3]                   ,
                        &self.__shape[2]                   ,
                        &self.__shape[1]                   ,
                        &self.__shape[0]                   ,
                        &self.__record                     ,
                        <double*> PyArray_DATA(self.__work))

        self.__record = self.__record + self.__recstep

        return self.__work


    def fread_sp5(self):
        # cdef np.ndarray[np.float32_t,ndim=3] result
        # result = np.empty((self.__shape[0],self.__shape[1],self.__shape[2]), dtype=np.float32)

        binio_fread_sp5(&self.__unit                      ,
                        &self.__shape[4]                  ,
                        &self.__shape[3]                  ,
                        &self.__shape[2]                  ,
                        &self.__shape[1]                  ,
                        &self.__shape[0]                  ,
                        &self.__record                    ,
                        <float*> PyArray_DATA(self.__work))

        self.__record = self.__record + self.__recstep

        return self.__work


    def fread_dp5(self):
        # cdef np.ndarray[np.float64_t,ndim=3] result
        # result = np.empty((self.__shape[0],self.__shape[1],self.__shape[2]), dtype=np.float64)

        binio_fread_dp5(&self.__unit                       ,
                        &self.__shape[4]                   ,
                        &self.__shape[3]                   ,
                        &self.__shape[2]                   ,
                        &self.__shape[1]                   ,
                        &self.__shape[0]                   ,
                        &self.__record                     ,
                        <double*> PyArray_DATA(self.__work))

        self.__record = self.__record + self.__recstep

        return self.__work


    def fread_sp6(self):
        # cdef np.ndarray[np.float32_t,ndim=3] result
        # result = np.empty((self.__shape[0],self.__shape[1],self.__shape[2]), dtype=np.float32)

        binio_fread_sp6(&self.__unit                      ,
                        &self.__shape[5]                  ,
                        &self.__shape[4]                  ,
                        &self.__shape[3]                  ,
                        &self.__shape[2]                  ,
                        &self.__shape[1]                  ,
                        &self.__shape[0]                  ,
                        &self.__record                    ,
                        <float*> PyArray_DATA(self.__work))

        self.__record = self.__record + self.__recstep

        return self.__work


    def fread_dp6(self):
        # cdef np.ndarray[np.float64_t,ndim=3] result
        # result = np.empty((self.__shape[0],self.__shape[1],self.__shape[2]), dtype=np.float64)

        binio_fread_dp6(&self.__unit                       ,
                        &self.__shape[5]                   ,
                        &self.__shape[4]                   ,
                        &self.__shape[3]                   ,
                        &self.__shape[2]                   ,
                        &self.__shape[1]                   ,
                        &self.__shape[0]                   ,
                        &self.__record                     ,
                        <double*> PyArray_DATA(self.__work))

        self.__record = self.__record + self.__recstep

        return self.__work


    def fwrite_sp1(self, np.ndarray[real_t, ndim=1] arr):
        cdef np.ndarray[np.float32_t,ndim=1] arr_cp = np.ascontiguousarray(arr, dtype=np.float32)
        if (arr_cp.shape[0] != self.__shape[0]):
            raise ValueError("Array shape mismatch")

        binio_fwrite_sp1(&self.__unit                 ,
                         &self.__shape[0]             ,
                         &self.__record               ,
                         <float*> PyArray_DATA(arr_cp))

        self.__record = self.__record + self.__recstep


    def fwrite_dp1(self, np.ndarray[real_t, ndim=1] arr):
        cdef np.ndarray[np.float64_t,ndim=1] arr_cp = np.ascontiguousarray(arr, dtype=np.float64)

        if (arr_cp.shape[0] != self.__shape[0]):
            raise ValueError("Array shape mismatch")

        binio_fwrite_dp1(&self.__unit                  ,
                         &self.__shape[0]              ,
                         &self.__record                ,
                         <double*> PyArray_DATA(arr_cp))

        self.__record = self.__record + self.__recstep


    def fwrite_sp2(self, np.ndarray[real_t, ndim=2] arr):
        cdef np.ndarray[np.float32_t,ndim=2] arr_cp = np.ascontiguousarray(arr, dtype=np.float32)

        if (arr_cp.shape[0] != self.__shape[0] or \
            arr_cp.shape[1] != self.__shape[1]):
            raise ValueError("Array shape mismatch")

        binio_fwrite_sp2(&self.__unit                 ,
                         &self.__shape[1]             ,
                         &self.__shape[0]             ,
                         &self.__record               ,
                         <float*> PyArray_DATA(arr_cp))

        self.__record = self.__record + self.__recstep


    def fwrite_dp2(self, np.ndarray[real_t, ndim=2] arr):
        cdef np.ndarray[np.float64_t,ndim=2] arr_cp = np.ascontiguousarray(arr, dtype=np.float64)

        if (arr_cp.shape[0] != self.__shape[0] or \
            arr_cp.shape[1] != self.__shape[1]):
            raise ValueError("Array shape mismatch")

        binio_fwrite_dp2(&self.__unit                  ,
                         &self.__shape[1]              ,
                         &self.__shape[0]              ,
                         &self.__record                ,
                         <double*> PyArray_DATA(arr_cp))

        self.__record = self.__record + self.__recstep


    def fwrite_sp3(self, np.ndarray[real_t, ndim=3] arr):
        cdef np.ndarray[np.float32_t,ndim=3] arr_cp = np.ascontiguousarray(arr, dtype=np.float32)

        if (arr_cp.shape[0] != self.__shape[0] or \
            arr_cp.shape[1] != self.__shape[1] or \
            arr_cp.shape[2] != self.__shape[2]):
            raise ValueError("Array shape mismatch")

        binio_fwrite_sp3(&self.__unit                 ,
                         &self.__shape[2]             ,
                         &self.__shape[1]             ,
                         &self.__shape[0]             ,
                         &self.__record               ,
                         <float*> PyArray_DATA(arr_cp))

        self.__record = self.__record + self.__recstep


    def fwrite_dp3(self, np.ndarray[real_t, ndim=3] arr):
        cdef np.ndarray[np.float64_t,ndim=3] arr_cp = np.ascontiguousarray(arr, dtype=np.float64)

        if (arr_cp.shape[0] != self.__shape[0] or \
            arr_cp.shape[1] != self.__shape[1] or \
            arr_cp.shape[2] != self.__shape[2]):
            raise ValueError("Array shape mismatch")

        binio_fwrite_dp3(&self.__unit                  ,
                         &self.__shape[2]              ,
                         &self.__shape[1]              ,
                         &self.__shape[0]              ,
                         &self.__record                ,
                         <double*> PyArray_DATA(arr_cp))

        self.__record = self.__record + self.__recstep


    def fwrite_sp4(self, np.ndarray[real_t, ndim=4] arr):
        cdef np.ndarray[np.float32_t,ndim=4] arr_cp = np.ascontiguousarray(arr, dtype=np.float32)

        if (arr_cp.shape[0] != self.__shape[0] or \
            arr_cp.shape[1] != self.__shape[1] or \
            arr_cp.shape[2] != self.__shape[2] or \
            arr_cp.shape[3] != self.__shape[3]):
            raise ValueError("Array shape mismatch")

        binio_fwrite_sp4(&self.__unit                 ,
                         &self.__shape[3]             ,
                         &self.__shape[2]             ,
                         &self.__shape[1]             ,
                         &self.__shape[0]             ,
                         &self.__record               ,
                         <float*> PyArray_DATA(arr_cp))

        self.__record = self.__record + self.__recstep


    def fwrite_dp4(self, np.ndarray[real_t, ndim=4] arr):
        cdef np.ndarray[np.float64_t,ndim=4] arr_cp = np.ascontiguousarray(arr, dtype=np.float64)

        if (arr_cp.shape[0] != self.__shape[0] or \
            arr_cp.shape[1] != self.__shape[1] or \
            arr_cp.shape[2] != self.__shape[2] or \
            arr_cp.shape[3] != self.__shape[3]):
            raise ValueError("Array shape mismatch")

        binio_fwrite_dp4(&self.__unit                  ,
                         &self.__shape[3]              ,
                         &self.__shape[2]              ,
                         &self.__shape[1]              ,
                         &self.__shape[0]              ,
                         &self.__record                ,
                         <double*> PyArray_DATA(arr_cp))

        self.__record = self.__record + self.__recstep


    def fwrite_sp5(self, np.ndarray[real_t, ndim=5] arr):
        cdef np.ndarray[np.float32_t,ndim=5] arr_cp = np.ascontiguousarray(arr, dtype=np.float32)

        if (arr_cp.shape[0] != self.__shape[0] or \
            arr_cp.shape[1] != self.__shape[1] or \
            arr_cp.shape[2] != self.__shape[2] or \
            arr_cp.shape[3] != self.__shape[3] or \
            arr_cp.shape[4] != self.__shape[4]):
            raise ValueError("Array shape mismatch")

        binio_fwrite_sp5(&self.__unit                 ,
                         &self.__shape[4]             ,
                         &self.__shape[3]             ,
                         &self.__shape[2]             ,
                         &self.__shape[1]             ,
                         &self.__shape[0]             ,
                         &self.__record               ,
                         <float*> PyArray_DATA(arr_cp))

        self.__record = self.__record + self.__recstep


    def fwrite_dp5(self, np.ndarray[real_t, ndim=5] arr):
        cdef np.ndarray[np.float64_t,ndim=5] arr_cp = np.ascontiguousarray(arr, dtype=np.float64)

        if (arr_cp.shape[0] != self.__shape[0] or \
            arr_cp.shape[1] != self.__shape[1] or \
            arr_cp.shape[2] != self.__shape[2] or \
            arr_cp.shape[3] != self.__shape[3] or \
            arr_cp.shape[4] != self.__shape[4]):
            raise ValueError("Array shape mismatch")

        binio_fwrite_dp5(&self.__unit                  ,
                         &self.__shape[4]              ,
                         &self.__shape[3]              ,
                         &self.__shape[2]              ,
                         &self.__shape[1]              ,
                         &self.__shape[0]              ,
                         &self.__record                ,
                         <double*> PyArray_DATA(arr_cp))

        self.__record = self.__record + self.__recstep


    def fwrite_sp6(self, np.ndarray[real_t, ndim=6] arr):
        cdef np.ndarray[np.float32_t,ndim=6] arr_cp = np.ascontiguousarray(arr, dtype=np.float32)

        if (arr_cp.shape[0] != self.__shape[0] or \
            arr_cp.shape[1] != self.__shape[1] or \
            arr_cp.shape[2] != self.__shape[2] or \
            arr_cp.shape[3] != self.__shape[3] or \
            arr_cp.shape[4] != self.__shape[4] or \
            arr_cp.shape[5] != self.__shape[5]):
            raise ValueError("Array shape mismatch")

        binio_fwrite_sp6(&self.__unit                 ,
                         &self.__shape[5]             ,
                         &self.__shape[4]             ,
                         &self.__shape[3]             ,
                         &self.__shape[2]             ,
                         &self.__shape[1]             ,
                         &self.__shape[0]             ,
                         &self.__record               ,
                         <float*> PyArray_DATA(arr_cp))

        self.__record = self.__record + self.__recstep


    def fwrite_dp6(self, np.ndarray[real_t, ndim=6] arr):
        cdef np.ndarray[np.float64_t,ndim=6] arr_cp = np.ascontiguousarray(arr, dtype=np.float64)

        if (arr_cp.shape[0] != self.__shape[0] or \
            arr_cp.shape[1] != self.__shape[1] or \
            arr_cp.shape[2] != self.__shape[2] or \
            arr_cp.shape[3] != self.__shape[3] or \
            arr_cp.shape[4] != self.__shape[4] or \
            arr_cp.shape[5] != self.__shape[5]):
            raise ValueError("Array shape mismatch")

        binio_fwrite_dp6(&self.__unit                  ,
                         &self.__shape[5]              ,
                         &self.__shape[4]              ,
                         &self.__shape[3]              ,
                         &self.__shape[2]              ,
                         &self.__shape[1]              ,
                         &self.__shape[0]              ,
                         &self.__record                ,
                         <double*> PyArray_DATA(arr_cp))

        self.__record = self.__record + self.__recstep

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





