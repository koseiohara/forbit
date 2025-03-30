#cython: language_level=3

import  numpy as np
cimport numpy as np
from numpy cimport PyArray_DATA

cimport cython
from libc.string cimport strlen, strncpy

cdef extern from 'binio.h':
    void binio_fopen(      int*  unit   ,
                     const int*  filelen,
                     const char* file   ,
                     const char* action ,
                     const int*  recl   ,
                     const char* endian );


    void binio_fclose(const int* unit);


    void binio_fread_sp1(const int*   unit      ,
                         const int*   nx        ,
                         const int*   record    ,
                               float* input_data);

    void binio_fread_dp1(const int*    unit      ,
                         const int*    nx        ,
                         const int*    record    ,
                               double* input_data);

    void binio_fread_sp2(const int*   unit      ,
                         const int*   nx        ,
                         const int*   ny        ,
                         const int*   record    ,
                               float* input_data);

    void binio_fread_dp2(const int*    unit      ,
                         const int*    nx        ,
                         const int*    ny        ,
                         const int*    record    ,
                               double* input_data);

    void binio_fread_sp3(const int*   unit      ,
                         const int*   nx        ,
                         const int*   ny        ,
                         const int*   nz        ,
                         const int*   record    ,
                               float* input_data);

    void binio_fread_dp3(const int*    unit      ,
                         const int*    nx        ,
                         const int*    ny        ,
                         const int*    nz        ,
                         const int*    record    ,
                               double* input_data);

    void binio_fwrite_sp1(const int*   unit       ,
                          const int*   nx         ,
                          const int*   record     ,
                                float* output_data);

    void binio_fwrite_dp1(const int*    unit       ,
                          const int*    nx         ,
                          const int*    record     ,
                                double* output_data);

    void binio_fwrite_sp2(const int*   unit       ,
                          const int*   nx         ,
                          const int*   ny         ,
                          const int*   record     ,
                                float* output_data);

    void binio_fwrite_dp2(const int*    unit       ,
                          const int*    nx         ,
                          const int*    ny         ,
                          const int*    record     ,
                                double* output_data);

    void binio_fwrite_sp3(const int*   unit       ,
                          const int*   nx         ,
                          const int*   ny         ,
                          const int*   nz         ,
                          const int*   record     ,
                                float* output_data);

    void binio_fwrite_dp3(const int*    unit       ,
                          const int*    nx         ,
                          const int*    ny         ,
                          const int*    nz         ,
                          const int*    record     ,
                                double* output_data);


#ctypedef fused shape_t:
#    np.ndarray[np.int32_t, ndim=1]
#    np.ndarray[np.int64_t, ndim=1]
#    list
#    tuple


ctypedef fused real_t:
    np.float32_t
    np.float64_t


#cdef const int filelen_max = 255
#cdef int filelen_max = 255
DEF FILELEN_MAX = 255


cdef class forbit:
    
    cdef char __file[FILELEN_MAX+1]
    cdef char* __action
    cdef char* __endian
    cdef char __order
    cdef int  __unit
    cdef int  __shape[3]
    cdef int  __kind
    cdef int  __record
    cdef int  __recstep

    cdef object fread
    cdef object fwrite


    #def __init__(self, const char* filename, const char* action, object shape, const int kind, const int record, const int recstep, const char* endian, const char order):
    def __init__(self, filename, action, object shape, const int kind, const int record, const int recstep, endian, order):
        #cdef size_t filename_size = strlen(filename)
        cdef np.ndarray shape_cp
        cdef int shape_size
        cdef int i
        cdef int recl

        cdef int precision
        cdef int work_filelen_max=FILELEN_MAX

        if (isinstance(filename, str)):
            filename = filename.encode('utf-8')
        else:
            raise TypeError('Invalid data type in the argument of forbit : filename')

        if (isinstance(action, str)):
            action = action.encode('utf-8')
        else:
            raise TypeError('Invalid data type in the argument of forbit : action')

        if (isinstance(endian, str)):
            endian = endian.encode('utf-8')
        else:
            raise TypeError('Invalid data type in the argument of forbit : endian')

        if (isinstance(order, str)):
            order = order.encode('utf-8')
        else:
            raise TypeError('Invalid data type in the argument of forbit : order')

        shape_cp = np.array(shape, dtype=np.intc)
        shape_size = shape_cp.size

        #cdef object[6] fread_list
        #cdef object[6] fwrite_list
        #cdef object fread_list[6]
        #cdef object fwrite_list[6]

        #shape_size = np.array(shape).size
        if (shape_size > 3):
            raise ValueError("Invalid number of dimensions")
        
        #strncpy(self.__file, filename, FILELEN_MAX)
        #self.__file[FILELEN_MAX] = b'\0'
        self.__file = <char*>filename
        self.__action = <char*>action
        self.__endian = <char*>endian
        self.__order  = <char>order[0]

        recl = kind
        for i in range(shape_size):
            self.__shape[i] = int(shape[i])
            recl = recl*self.__shape[i]
        
        self.__kind    = kind
        self.__record  = record
        self.__recstep = recstep

        binio_fopen(&self.__unit       ,
                    &work_filelen_max,
                    self.__file        ,
                    self.__action      ,
                    &recl              ,
                    self.__endian      )

        fread_list = [self.fread_sp1,
                      self.fread_dp1,
                      self.fread_sp2,
                      self.fread_dp2,
                      self.fread_sp3,
                      self.fread_dp3]

        fwrite_list = [self.fwrite_sp1,
                       self.fwrite_dp1,
                       self.fwrite_sp2,
                       self.fwrite_dp2,
                       self.fwrite_sp3,
                       self.fwrite_dp3]

        precision = kind >> 2
        self.fread  =  fread_list[((shape_size-1)<<1)+precision-1]
        self.fwrite = fwrite_list[((shape_size-1)<<1)+precision-1]


    def __del__(self):
        self.close()


    def close(self):
        binio_fclose(&self.__unit)
        self.__unit = -999999


    def fread_sp1(self):
        cdef np.ndarray[np.float32_t,ndim=1] result
        result = np.empty(self.__shape[0], dtype=np.float32)

        binio_fread_sp1(&self.__unit    ,
                        &self.__shape[0],
                        &self.__record  ,
                        <float*> PyArray_DATA(result)          )
                        #result          )

        self.__record = self.__record + self.__recstep

        return result


    def fread_dp1(self):
        cdef np.ndarray[np.float64_t,ndim=1] result
        result = np.empty(self.__shape[0], dtype=np.float64)

        binio_fread_dp1(&self.__unit    ,
                        &self.__shape[0],
                        &self.__record  ,
                        <double*> PyArray_DATA(result)          )
                        #result          )

        self.__record = self.__record + self.__recstep

        return result
        

    def fread_sp2(self):
        cdef np.ndarray[np.float32_t,ndim=2] result
        result = np.empty((self.__shape[0],self.__shape[1]), dtype=np.float32)

        binio_fread_sp2(&self.__unit    ,
                        &self.__shape[0],
                        &self.__shape[1],
                        &self.__record  ,
                        <float*> PyArray_DATA(result)          )
                        #result          )

        self.__record = self.__record + self.__recstep

        return result


    def fread_dp2(self):
        cdef np.ndarray[np.float64_t,ndim=2] result
        result = np.empty((self.__shape[0],self.__shape[1]), dtype=np.float64)

        binio_fread_dp2(&self.__unit    ,
                        &self.__shape[0],
                        &self.__shape[1],
                        &self.__record  ,
                        <double*> PyArray_DATA(result)          )
                        #result          )

        self.__record = self.__record + self.__recstep

        return result


    def fread_sp3(self):
        cdef np.ndarray[np.float32_t,ndim=3] result
        result = np.empty((self.__shape[0],self.__shape[1],self.__shape[2]), dtype=np.float32)

        binio_fread_sp3(&self.__unit    ,
                        &self.__shape[0],
                        &self.__shape[1],
                        &self.__shape[2],
                        &self.__record  ,
                        <float*> PyArray_DATA(result)          )
                        #result          )

        self.__record = self.__record + self.__recstep

        return result


    def fread_dp3(self):
        cdef np.ndarray[np.float64_t,ndim=3] result
        result = np.empty((self.__shape[0],self.__shape[1],self.__shape[2]), dtype=np.float64)

        binio_fread_dp3(&self.__unit    ,
                        &self.__shape[0],
                        &self.__shape[1],
                        &self.__shape[2],
                        &self.__record  ,
                        <double*> PyArray_DATA(result)          )

        self.__record = self.__record + self.__recstep

        return result


    def fwrite_sp1(self, np.ndarray[real_t, ndim=1] arr):
        #cdef float[:] arr_view = arr
        cdef np.ndarray[np.float32_t,ndim=1] arr_cp = arr

        binio_fwrite_sp1(&self.__unit    ,
                         &self.__shape[0],
                         &self.__record  ,
                         <float*> PyArray_DATA(arr_cp))
                         #<float*> arr_view.data)
                         #&arr_view[0])
                         #arr.astype(np.float32) )
                         #np.float32(arr) )

        self.__record = self.__record + self.__recstep


    def fwrite_dp1(self, np.ndarray[real_t, ndim=1] arr):
        #cdef double[:] arr_view = arr
        cdef np.ndarray[np.float64_t,ndim=1] arr_cp = arr

        binio_fwrite_dp1(&self.__unit    ,
                         &self.__shape[0],
                         &self.__record  ,
                         <double*> PyArray_DATA(arr_cp))
                         #<double*> arr_view.data)
                         #&arr_view[0])
                         #arr.astype(np.float64) )
                         #np.float64(arr) )

        self.__record = self.__record + self.__recstep


    def fwrite_sp2(self, np.ndarray[real_t, ndim=2] arr):
        #cdef float[:,:] arr_view = arr
        cdef np.ndarray[np.float32_t,ndim=2] arr_cp = arr

        binio_fwrite_sp2(&self.__unit    ,
                         &self.__shape[0],
                         &self.__shape[1],
                         &self.__record  ,
                         <float*> PyArray_DATA(arr_cp))
                         #<float*> arr_view.data)
                         #&arr_view[0])
                         #arr.astype(np.float32) )
                         #np.float32(arr) )

        self.__record = self.__record + self.__recstep


    def fwrite_dp2(self, np.ndarray[real_t, ndim=2] arr):
        #cdef double[:,:] arr_view = arr
        cdef np.ndarray[np.float64_t,ndim=2] arr_cp = arr

        binio_fwrite_dp2(&self.__unit    ,
                         &self.__shape[0],
                         &self.__shape[1],
                         &self.__record  ,
                         <double*> PyArray_DATA(arr_cp))
                         #<double*> arr_view.data)
                         #&arr_view[0])
                         #arr.astype(np.float64) )
                         #np.float64(arr) )

        self.__record = self.__record + self.__recstep


    def fwrite_sp3(self, np.ndarray[real_t, ndim=3] arr):
        #cdef float[:,:,:] arr_view = arr
        cdef np.ndarray[np.float32_t,ndim=3] arr_cp = arr

        binio_fwrite_sp3(&self.__unit    ,
                         &self.__shape[0],
                         &self.__shape[1],
                         &self.__shape[2],
                         &self.__record  ,
                         <float*> PyArray_DATA(arr_cp))
                         #<float*> arr_view.data)
                         #&arr_view[0])
                         #arr.astype(np.float32) )
                         #np.float32(arr) )

        self.__record = self.__record + self.__recstep


    def fwrite_dp3(self, np.ndarray[real_t, ndim=3] arr):
        #cdef double[:,:,:] arr_view = arr
        cdef np.ndarray[np.float64_t,ndim=3] arr_cp = arr

        binio_fwrite_dp3(&self.__unit    ,
                         &self.__shape[0],
                         &self.__shape[1],
                         &self.__shape[2],
                         &self.__record  ,
                         <double*> PyArray_DATA(arr_cp))
                         #<double*> arr_view.data)
                         #arr.astype(np.float64) )
                         #np.float64(arr) )

        self.__record = self.__record + self.__recstep


    def get_record(self):
        return self.__record


    def reset_record(self, object newRecord=None, object increment=None):
        if (newRecord is not None):
            self.__record = <int>newRecord
            return
        elif (increment is not None):
            self.__record = self.__record + <int>increment
            return

        raise ValueError("In forbit.reset_record() :\nAt least one of 'newRecord' or 'increment' must be provided")





