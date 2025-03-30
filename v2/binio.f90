! 
! Binary file reader for Python.
! Compile with f2py and import this module by 'import binio'
! 
! Provided by Kosei Ohara
! 
module binio
    use iso_c_binding
    
    implicit none

    private
    public :: binio_fopen
    public :: binio_fclose
    public :: binio_fread_sp1 , binio_fread_dp1 , binio_fread_sp2 , binio_fread_dp2 , binio_fread_sp3 , binio_fread_dp3
    public :: binio_fwrite_sp1, binio_fwrite_dp1, binio_fwrite_sp2, binio_fwrite_dp2, binio_fwrite_sp3, binio_fwrite_dp3


    contains


    subroutine binio_fopen(unit, filelen, file, action, recl, endian) bind(C)
        integer(c_int)   , intent(out) :: unit
        integer(c_int)   , intent(in)  :: filelen
        character(c_char), intent(in)  :: file(*)
        character(c_char), intent(in)  :: action
        integer(c_int)   , intent(in)  :: recl
        character(c_char), intent(in)  :: endian

        integer, parameter :: filelen_max = 256
        character(filelen_max) :: file_cp
        character(16)          :: available_action
        character(16)          :: available_endian
        integer :: i

        if (recl <= 0) then
            write(*,'(A)')    '<ERROR STOP>'
            write(*,'(A,I0)') 'Invalid record length : ', recl
            write(*,'(A)')    'Argument "recl" should be more than 0'
            ERROR STOP
        endif

        if (filelen > filelen_max) then
            write(*,'(A)')    '<ERROR STOP>'
            write(*,'(A,I0)') 'Length of filename is too long : ', filelen
            write(*,'(A,I0)') 'The maximum length is ', filelen_max
            ERROR STOP
        endif

        file_cp = repeat(' ', filelen_max)
        do i = 1, filelen
            file_cp(i:i) = file(i)
        enddo

        if (action == 'r') then
            available_action = 'read'
        else
            available_action = 'write'
        endif

        if (endian == 'l') then
            available_endian = 'little_endian'
        else
            available_endian = 'big_endian'
        endif

        open(NEWUNIT=unit                  , &
           & FILE   =trim(file_cp)         , &
           & ACTION =trim(available_action), &
           & FORM   ='UNFORMATTED'         , &
           & ACCESS ='DIRECT'              , &
           & RECL   =recl                  , &
           & CONVERT=trim(available_endian)  )

    end subroutine binio_fopen


    subroutine binio_fclose(unit) bind(C)
        integer(c_int), intent(in) :: unit
        logical :: open_status

        INQUIRE(unit              , &  !! IN
              & OPENED=open_status  )  !! OUT

        if (open_status) then
            close(unit)
        endif

    end subroutine binio_fclose


    subroutine binio_fread_sp1(unit, nx, record, input_data) bind(C)
        integer(c_int), intent(in)  :: unit
        integer(c_int), intent(in)  :: nx
        integer(c_int), intent(in)  :: record
        real(c_float) , intent(out) :: input_data(nx)

        read(unit,rec=record) input_data(1:nx)

    end subroutine binio_fread_sp1


    subroutine binio_fread_dp1(unit, nx, record, input_data) bind(C)
        integer(c_int), intent(in)  :: unit
        integer(c_int), intent(in)  :: nx
        integer(c_int), intent(in)  :: record
        real(c_double), intent(out) :: input_data(nx)

        read(unit,rec=record) input_data(1:nx)

    end subroutine binio_fread_dp1


    subroutine binio_fread_sp2(unit, nx, ny, record, input_data) bind(C)
        integer(c_int), intent(in)  :: unit
        integer(c_int), intent(in)  :: nx
        integer(c_int), intent(in)  :: ny
        integer(c_int), intent(in)  :: record
        real(c_float) , intent(out) :: input_data(nx,ny)

        read(unit,rec=record) input_data(1:nx,1:ny)

    end subroutine binio_fread_sp2


    subroutine binio_fread_dp2(unit, nx, ny, record, input_data) bind(C)
        integer(c_int), intent(in)  :: unit
        integer(c_int), intent(in)  :: nx
        integer(c_int), intent(in)  :: ny
        integer(c_int), intent(in)  :: record
        real(c_double), intent(out) :: input_data(nx,ny)

        read(unit,rec=record) input_data(1:nx,1:ny)

    end subroutine binio_fread_dp2


    subroutine binio_fread_sp3(unit, nx, ny, nz, record, input_data) bind(C)
        integer(c_int), intent(in)  :: unit
        integer(c_int), intent(in)  :: nx
        integer(c_int), intent(in)  :: ny
        integer(c_int), intent(in)  :: nz
        integer(c_int), intent(in)  :: record
        real(c_float) , intent(out) :: input_data(nx,ny,nz)

        read(unit,rec=record) input_data(1:nx,1:ny,1:nz)

    end subroutine binio_fread_sp3


    subroutine binio_fread_dp3(unit, nx, ny, nz, record, input_data) bind(C)
        integer(c_int), intent(in)  :: unit
        integer(c_int), intent(in)  :: nx
        integer(c_int), intent(in)  :: ny
        integer(c_int), intent(in)  :: nz
        integer(c_int), intent(in)  :: record
        real(c_double), intent(out) :: input_data(nx,ny,nz)

        read(unit,rec=record) input_data(1:nx,1:ny,1:nz)

    end subroutine binio_fread_dp3


    subroutine binio_fwrite_sp1(unit, nx, record, output_data) bind(C)
        integer(c_int), intent(in) :: unit
        integer(c_int), intent(in) :: nx
        integer(c_int), intent(in) :: record
        real(c_float) , intent(in) :: output_data(nx)

        write(unit,rec=record) output_data(1:nx)

    end subroutine binio_fwrite_sp1


    subroutine binio_fwrite_dp1(unit, nx, record, output_data) bind(C)
        integer(c_int), intent(in) :: unit
        integer(c_int), intent(in) :: nx
        integer(c_int), intent(in) :: record
        real(c_double), intent(in) :: output_data(1:nx)

        write(unit,rec=record) output_data(1:nx)

    end subroutine binio_fwrite_dp1


    subroutine binio_fwrite_sp2(unit, nx, ny, record, output_data) bind(C)
        integer(c_int), intent(in) :: unit
        integer(c_int), intent(in) :: nx
        integer(c_int), intent(in) :: ny
        integer(c_int), intent(in) :: record
        real(c_float) , intent(in) :: output_data(1:nx,1:ny)

        write(unit,rec=record) output_data(1:nx,1:ny)

    end subroutine binio_fwrite_sp2


    subroutine binio_fwrite_dp2(unit, nx, ny, record, output_data) bind(C)
        integer(c_int), intent(in) :: unit
        integer(c_int), intent(in) :: nx
        integer(c_int), intent(in) :: ny
        integer(c_int), intent(in) :: record
        real(c_double), intent(in) :: output_data(1:nx,1:ny)

        write(unit,rec=record) output_data(1:nx,1:ny)

    end subroutine binio_fwrite_dp2


    subroutine binio_fwrite_sp3(unit, nx, ny, nz, record, output_data) bind(C)
        integer(c_int), intent(in) :: unit
        integer(c_int), intent(in) :: nx
        integer(c_int), intent(in) :: ny
        integer(c_int), intent(in) :: nz
        integer(c_int), intent(in) :: record
        real(c_float) , intent(in) :: output_data(1:nx,1:ny,1:nz)

        write(unit,rec=record) output_data(1:nx,1:ny,1:nz)

    end subroutine binio_fwrite_sp3


    subroutine binio_fwrite_dp3(unit, nx, ny, nz, record, output_data) bind(C)
        integer(c_int), intent(in) :: unit
        integer(c_int), intent(in) :: nx
        integer(c_int), intent(in) :: ny
        integer(c_int), intent(in) :: nz
        integer(c_int), intent(in) :: record
        real(c_double), intent(in) :: output_data(1:nx,1:ny,1:nz)

        write(unit,rec=record) output_data(1:nx,1:ny,1:nz)

    end subroutine binio_fwrite_dp3


end module binio

