import numpy as np
import dabin

class fileio:

    def __init__(self, filename, action, nx, ny, nz, kind, record, recstep, endian):

        self.__checker(filename, action, nx, ny, nz, kind, record, recstep, endian)

        self.__file    = filename
        self.__nx      = nx
        self.__ny      = ny
        self.__nz      = nz
        self.__record  = record
        self.__recstep = recstep

        recl = kind*nx*ny*nz
        
        self.__unit = dabin.fopen(file  =filename, \
                                  action=action  , \
                                  recl  =recl    , \
                                  endian=endian    )

        if (kind == 4):
            self.fread  = self.fread_sp
            self.fwrite = self.fwrite_sp
        if (kind == 8):
            self.fread  = self.fread_dp
            self.fwrite = self.fwrite_dp


    def __del__(self):
        self.close()


    def close(self):
        dabin.fclose(self.__unit)
        self.__unit = -99999


    def fread_sp(self):
        result = dabin.fread_sp(self.__unit  , \
                                self.__nx    , \
                                self.__ny    , \
                                self.__nz    , \
                                self.__record  )

        self.__record = self.__record + self.__recstep

        if (np.any(np.isnan(result))):
            print('')
            print('Warning from fread : Input data contains NaN value.')
            print('    File Name : {}'.format(self.__filename))
            print('    Record    : {}'.format(self.record))
            print('')

        return result
                     
    
    def fread_dp(self):
        result = dabin.fread_dp(self.__unit  , \
                                self.__nx    , \
                                self.__ny    , \
                                self.__nz    , \
                                self.__record  )

        self.__record = self.__record + self.__recstep

        if (np.any(np.isnan(result))):
            print('')
            print('Warning from fread : Input data contains NaN value.')
            print('    File Name : {}'.format(self.__filename))
            print('    Record    : {}'.format(self.record))
            print('')

        return result
                     
    
    def fwrite_sp(self, dataArray):
        dataArray_sp = np.float32(dataArray)
        dabin.fwrite_sp(self.__unit  , \
                        self.__nx    , \
                        self.__ny    , \
                        self.__nz    , \
                        self.__record, \
                        dataArray_sp   )

        self.__record = self.__record + self.__recstep


    def fwrite_dp(self, dataArray):
        dabin.fwrite_sp(self.__unit  , \
                        self.__nx    , \
                        self.__ny    , \
                        self.__nz    , \
                        self.__record, \
                        dataArray      )

        self.__record = self.__record + self.__recstep


    def get_record(self):
        result = self.__record
        return result


    def reset_record(self, newRecord=None, increment=None):
        if (newRecord is not None):
            self.__record = newRecord
            return
        elif (increment is not None):
            self.__record = self.__record + increment
            return
        
        raise ValueError('At least one of "newRecord" or "increment" must be provided')


    def __checker(self, filename, action, nx, ny, nz, kind, record, recstep, endian):

        if (type(filename) is not str):
            raise TypeError('The "filename" argument must be a string.')

        if (type(action) is not str):
            raise TypeError('The "action" argument must be a string.')

        if (action.lower() != 'write' and action.lower() != 'read' and action.lower() != 'readwrite'):
            raise ValueError('The "action" argument must be either "read", "write", or "readwrite"')

        if(type(nx) is not int):
            raise TypeError('The "nx" argument must be an integer.')

        if(type(ny) is not int):
            raise TypeError('The "ny" argument must be an integer.')

        if(type(nz) is not int):
            raise TypeError('The "nz" argument must be an integer.')

        if (nx < 1):
            raise ValueError('The "nx" argument must be a positive integer')

        if (ny < 1):
            raise ValueError('The "ny" argument must be a positive integer')

        if (nz < 1):
            raise ValueError('The "nz" argument must be a positive integer')

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

