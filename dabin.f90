! 
! Binary file reader for Python.
! Compile with f2py and import this module by 'import dabin'
! 
! Provided by Kosei Ohara
! 


subroutine fopen(unit, file, action, recl, endian)
    implicit none

    integer     , intent(out) :: unit
    character(*), intent(in)  :: file
    character(*), intent(in)  :: action
    integer     , intent(in)  :: recl
    character(*), intent(in)  :: endian

    if (recl <= 0) then
        write(*,'(A)') 'ERROR STOP'
        write(*,'(A,I0)') 'Invalid record length : ', recl
        write(*,'(A)') 'Argument "recl" should be more than 0'
        ERROR STOP
    endif

    open(NEWUNIT=unit         , &
       & FILE   =file         , &
       & ACTION =action       , &
       & FORM   ='UNFORMATTED', &
       & ACCESS ='DIRECT'     , &
       & RECL   =recl         , &
       & CONVERT=endian         )

end subroutine fopen


subroutine fclose(unit)
    implicit none

    integer, intent(in) :: unit
    logical :: open_status

    INQUIRE(unit              , &  !! IN
          & OPENED=open_status  )  !! OUT

    if (open_status) then
        close(unit)
    endif

end subroutine fclose


subroutine fread_sp1(unit, nx, record, input_data)
    implicit none

    integer, intent(in)  :: unit
    integer, intent(in)  :: nx
    integer, intent(in)  :: record
    real(4), intent(out) :: input_data(nx)

    read(unit,rec=record) input_data(1:nx)

end subroutine fread_sp1


subroutine fread_dp1(unit, nx, record, input_data)
    implicit none

    integer, intent(in)  :: unit
    integer, intent(in)  :: nx
    integer, intent(in)  :: record
    real(8), intent(out) :: input_data(nx)

    read(unit,rec=record) input_data(1:nx)

end subroutine fread_dp1


subroutine fread_sp2(unit, nx, ny, record, input_data)
    implicit none

    integer, intent(in)  :: unit
    integer, intent(in)  :: nx
    integer, intent(in)  :: ny
    integer, intent(in)  :: record
    real(4), intent(out) :: input_data(nx,ny)

    read(unit,rec=record) input_data(1:nx,1:ny)

end subroutine fread_sp2


subroutine fread_dp2(unit, nx, ny, record, input_data)
    implicit none

    integer, intent(in)  :: unit
    integer, intent(in)  :: nx
    integer, intent(in)  :: ny
    integer, intent(in)  :: record
    real(8), intent(out) :: input_data(nx,ny)

    read(unit,rec=record) input_data(1:nx,1:ny)

end subroutine fread_dp2


subroutine fread_sp3(unit, nx, ny, nz, record, input_data)
    implicit none

    integer, intent(in)  :: unit
    integer, intent(in)  :: nx
    integer, intent(in)  :: ny
    integer, intent(in)  :: nz
    integer, intent(in)  :: record
    real(4), intent(out) :: input_data(nx,ny,nz)

    read(unit,rec=record) input_data(1:nx,1:ny,1:nz)

end subroutine fread_sp3


subroutine fread_dp3(unit, nx, ny, nz, record, input_data)
    implicit none

    integer, intent(in)  :: unit
    integer, intent(in)  :: nx
    integer, intent(in)  :: ny
    integer, intent(in)  :: nz
    integer, intent(in)  :: record
    real(8), intent(out) :: input_data(nx,ny,nz)

    read(unit,rec=record) input_data(1:nx,1:ny,1:nz)

end subroutine fread_dp3


subroutine fwrite_sp1(unit, record, output_data)
    implicit none

    integer, intent(in) :: unit
    integer, intent(in) :: record
    real(4), intent(in) :: output_data(:)

    write(unit,rec=record) output_data(:)

end subroutine fwrite_sp1


subroutine fwrite_dp1(unit, record, output_data)
    implicit none

    integer, intent(in) :: unit
    integer, intent(in) :: record
    real(8), intent(in) :: output_data(:)

    write(unit,rec=record) output_data(:)

end subroutine fwrite_dp1


subroutine fwrite_sp2(unit, record, output_data)
    implicit none

    integer, intent(in) :: unit
    integer, intent(in) :: record
    real(4), intent(in) :: output_data(:,:)

    write(unit,rec=record) output_data(:,:)

end subroutine fwrite_sp2


subroutine fwrite_dp2(unit, record, output_data)
    implicit none

    integer, intent(in) :: unit
    integer, intent(in) :: record
    real(8), intent(in) :: output_data(:,:)

    write(unit,rec=record) output_data(:,:)

end subroutine fwrite_dp2


subroutine fwrite_sp3(unit, record, output_data)
    implicit none

    integer, intent(in) :: unit
    integer, intent(in) :: record
    real(4), intent(in) :: output_data(:,:,:)

    write(unit,rec=record) output_data(:,:,:)

end subroutine fwrite_sp3


subroutine fwrite_dp3(unit, record, output_data)
    implicit none

    integer, intent(in) :: unit
    integer, intent(in) :: record
    real(8), intent(in) :: output_data(:,:,:)

    write(unit,rec=record) output_data(:,:,:)

end subroutine fwrite_dp3



