

program gen_fort_bin

    use iso_fortran_env, only : real32, real64

    implicit none

    integer, parameter :: nx = 3
    integer, parameter :: ny = 4
    integer, parameter :: nz = 5
    integer, parameter :: nr = 2
    real(real32) :: arrReal32(nx,ny,nz,nr)
    real(real64) :: arrReal64(nx,ny,nz,nr)
    integer :: i
    integer :: j
    integer :: unit32
    integer :: unit64

    do j = 1, nr
        arrReal32(1:nx,1:ny,1:nz,j) = reshape([(real(i+j, kind=real32), i=1,nx*ny*nz)], [nx,ny,nz])
        arrReal64(1:nx,1:ny,1:nz,j) = reshape([(real(i+j, kind=real64), i=1,nx*ny*nz)], [nx,ny,nz])
    enddo

    open(newunit=unit32                       , &
       & file   ='./binary/fortran_real32.grd', &
       & action ='write'                      , &
       & form   ='unformatted'                , &
       & access ='direct'                     , &
       & recl   =4*nx*ny*nz                   , &
       & convert='little_endian'                )

    open(newunit=unit64                       , &
       & file   ='./binary/fortran_real64.grd', &
       & action ='write'                      , &
       & form   ='unformatted'                , &
       & access ='direct'                     , &
       & recl   =8*nx*ny*nz                   , &
       & convert='little_endian'                )

    do j = 1, nr
        write(unit32,rec=j) arrReal32(1:nx,1:ny,1:nz,j)
        write(unit64,rec=j) arrReal64(1:nx,1:ny,1:nz,j)
    enddo

    close(unit32)
    close(unit64)

end program gen_fort_bin

