

program gen_fort_bin

    use iso_fortran_env, only : int16, int32, int64, real32, real64

    implicit none

    integer, parameter :: nx = 3
    integer, parameter :: ny = 4
    integer, parameter :: nz = 5
    integer, parameter :: nr = 2
    integer(int16) :: arrInt16(nx,ny,nz,nr)
    integer(int32) :: arrInt32(nx,ny,nz,nr)
    integer(int64) :: arrInt64(nx,ny,nz,nr)
    real(real32)   :: arrReal32(nx,ny,nz,nr)
    real(real64)   :: arrReal64(nx,ny,nz,nr)
    integer :: i
    integer :: j
    integer :: uniti16
    integer :: uniti32
    integer :: uniti64
    integer :: unitr32
    integer :: unitr64

    do j = 1, nr
        arrInt16(1:nx,1:ny,1:nz,j)  = reshape([( int(i+j, kind=int16 ), i=1,nx*ny*nz)], [nx,ny,nz])
        arrInt32(1:nx,1:ny,1:nz,j)  = reshape([( int(i+j, kind=int32 ), i=1,nx*ny*nz)], [nx,ny,nz])
        arrInt64(1:nx,1:ny,1:nz,j)  = reshape([( int(i+j, kind=int64 ), i=1,nx*ny*nz)], [nx,ny,nz])
        arrReal32(1:nx,1:ny,1:nz,j) = reshape([(real(i+j, kind=real32), i=1,nx*ny*nz)], [nx,ny,nz])
        arrReal64(1:nx,1:ny,1:nz,j) = reshape([(real(i+j, kind=real64), i=1,nx*ny*nz)], [nx,ny,nz])
    enddo

    open(newunit=uniti16                     , &
       & file   ='./binary/fortran_int16.grd', &
       & action ='write'                     , &
       & form   ='unformatted'               , &
       & access ='direct'                    , &
       & recl   =2*nx*ny*nz                  , &
       & convert='little_endian'               )

    open(newunit=uniti32                     , &
       & file   ='./binary/fortran_int32.grd', &
       & action ='write'                     , &
       & form   ='unformatted'               , &
       & access ='direct'                    , &
       & recl   =4*nx*ny*nz                  , &
       & convert='little_endian'               )

    open(newunit=uniti64                     , &
       & file   ='./binary/fortran_int64.grd', &
       & action ='write'                     , &
       & form   ='unformatted'               , &
       & access ='direct'                    , &
       & recl   =8*nx*ny*nz                  , &
       & convert='little_endian'               )

    open(newunit=unitr32                       , &
       & file   ='./binary/fortran_real32.grd', &
       & action ='write'                      , &
       & form   ='unformatted'                , &
       & access ='direct'                     , &
       & recl   =4*nx*ny*nz                   , &
       & convert='little_endian'                )

    open(newunit=unitr64                       , &
       & file   ='./binary/fortran_real64.grd', &
       & action ='write'                      , &
       & form   ='unformatted'                , &
       & access ='direct'                     , &
       & recl   =8*nx*ny*nz                   , &
       & convert='little_endian'                )

    do j = 1, nr
        write(uniti16,rec=j) arrInt16(1:nx,1:ny,1:nz,j)
        write(uniti32,rec=j) arrInt32(1:nx,1:ny,1:nz,j)
        write(uniti64,rec=j) arrInt64(1:nx,1:ny,1:nz,j)
        write(unitr32,rec=j) arrReal32(1:nx,1:ny,1:nz,j)
        write(unitr64,rec=j) arrReal64(1:nx,1:ny,1:nz,j)
    enddo

    close(uniti16)
    close(uniti32)
    close(uniti64)
    close(unitr32)
    close(unitr64)

end program gen_fort_bin

