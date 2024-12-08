#
# A class to call dabin sufficiently.
# See sample.py for usage
#
# Provided by Kosei Ohara
#


import numpy as np
import dabin

class fileio:

    def __init__(self, filename, action, shape, kind, record, recstep, endian):
        
        shape = np.array(shape)
        dim   = np.size(shape)

        # Validate the arguments
        self.__checker(filename, action, shape, kind, record, recstep, endian)

        self.__file    = filename
        self.__shape   = shape[:]
        self.__record  = record
        self.__recstep = recstep

        # Record length
        recl = kind*np.prod(shape)
       
        # List of fread related functions
        fread_list  = [self.fread_sp_1dim, 
                       self.fread_dp_1dim, 
                       self.fread_sp_2dim, 
                       self.fread_dp_2dim, 
                       self.fread_sp_3dim, 
                       self.fread_dp_3dim]

        # List of fwrite related functions
        dabin_fwrite_list = [dabin.fwrite_sp1, 
                             dabin.fwrite_dp1, 
                             dabin.fwrite_sp2, 
                             dabin.fwrite_dp2, 
                             dabin.fwrite_sp3, 
                             dabin.fwrite_dp3]

        # Determine functions based on the values of the kind and the dim
        precision = kind >> 2
        self.fread = fread_list[((dim-1)<<1)+precision-1]

        self.dabin_fwrite = dabin_fwrite_list[((dim-1)<<1)+precision-1]
        if (precision == 1):
            self.fwrite = self.fwrite_sp
        if (precision == 2):
            self.fwrite = self.fwrite_dp

        # Open a file and get a unit number
        self.__unit = dabin.fopen(file  =filename, \
                                  action=action  , \
                                  recl  =recl    , \
                                  endian=endian    )


    def __del__(self):
        self.close()


    def close(self):
        dabin.fclose(self.__unit)

        self.__unit    = -9999999
        self.__file    = 'ERROR'
        self.__shape   = None
        self.__record  = None
        self.__recstep = None


    def fread_sp_1dim(self):
        result = dabin.fread_sp1(self.__unit    , \
                                 self.__shape[0], \
                                 self.__record    )

        self.__record = self.__record + self.__recstep

        self.__nanDetector(result)

        return result
                     
    
    def fread_dp_1dim(self):
        result = dabin.fread_dp1(self.__unit    , \
                                 self.__shape[0], \
                                 self.__record    )

        self.__record = self.__record + self.__recstep

        self.__nanDetector(result)

        return result


    def fread_sp_2dim(self):
        result = dabin.fread_sp2(self.__unit    , \
                                 self.__shape[0], \
                                 self.__shape[1], \
                                 self.__record    )

        self.__record = self.__record + self.__recstep

        self.__nanDetector(result)

        return result
                     
    
    def fread_dp_2dim(self):
        result = dabin.fread_dp2(self.__unit    , \
                                 self.__shape[0], \
                                 self.__shape[1], \
                                 self.__record    )

        self.__record = self.__record + self.__recstep

        self.__nanDetector(result)

        return result
                     
    
    def fread_sp_3dim(self):
        result = dabin.fread_sp3(self.__unit    , \
                                 self.__shape[0], \
                                 self.__shape[1], \
                                 self.__shape[2], \
                                 self.__record    )

        self.__record = self.__record + self.__recstep

        self.__nanDetector(result)

        return result
                     
    
    def fread_dp_3dim(self):
        result = dabin.fread_dp3(self.__unit    , \
                                 self.__shape[0], \
                                 self.__shape[1], \
                                 self.__shape[2], \
                                 self.__record    )

        self.__nanDetector(result)

        self.__record = self.__record + self.__recstep

        return result
                     
    
    def fwrite_sp(self, dataArray):
        dataArray_sp = np.float32(dataArray)
        self.dabin_fwrite(self.__unit, \
                     self.__record   , \
                     dataArray_sp      )

        self.__record = self.__record + self.__recstep


    def fwrite_dp(self, dataArray):
        self.dabin_fwrite(self.__unit, \
                     self.__record   , \
                     dataArray         )

        self.__record = self.__record + self.__recstep


    # Check values
    def __nanDetector(self, dataArray):
        if (np.any(np.isnan(dataArray))):
            print('')
            print('Warning from fread : Input data contains NaN value.')
            print('    File Name : {}'.format(self.__filename))
            print('    Record    : {}'.format(self.record))
            print('')


    # Inquire the present record
    def get_record(self):
        result = self.__record
        return result


    # Reset the record
    # If newRecord is provided, the record will be updated to that value.
    # If increment is provided without newRecord, the increment value will be added to the record.
    def reset_record(self, newRecord=None, increment=None):
        if (newRecord is not None):
            self.__record = newRecord
            return
        elif (increment is not None):
            self.__record = self.__record + increment
            return
        
        raise ValueError('At least one of "newRecord" or "increment" must be provided')


    # Validation
    def __checker(self, filename, action, shape, kind, record, recstep, endian):

        if (type(filename) is not str):
            raise TypeError('The "filename" argument must be a string.')

        if (type(action) is not str):
            raise TypeError('The "action" argument must be a string.')

        if (action.lower() != 'write' and action.lower() != 'read' and action.lower() != 'readwrite'):
            raise ValueError('The "action" argument must be either "read", "write", or "readwrite"')

        if (not isinstance(shape[0], (int, np.integer))):
            raise TypeError('All of the "shape" elements must be integers.')

        if (np.any(shape[:] < 1)):
            raise ValueError('All of the "shape" elements must be positive integers')

        if (np.size(shape) > 3):
            raise ValueError('The "shape" size must be betweem 1 and 3')

        if (type(kind) is not int):
            raise TypeError('The "kind" argument must be an integer.')

        if (kind != 4 and kind != 8):
            raise ValueError('The "kind" argument must be either 4 or 8.')

        if (type(record) is not int):
            raise TypeError('The "record" argument must be an integer.')

        if (type(recstep) is not int):
            raise TypeError('The "recstep" argument must be an integer.')

        if (type(endian) is not str):
            raise TypeError('The "endian" argument must be a string.')

        if (endian.lower() != 'little_endian' and endian.lower() != 'big_endian'):
            raise ValueError('The "endian" argument must be either "little_endian" or "big_endian".')

