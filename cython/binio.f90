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


    !subroutine binio_fopen(unit, filelen, file, action, recl, endian) bind(C)
    subroutine binio_fopen(unit, file, action, recl, endian) bind(C)
        integer(c_int)   , intent(out) :: unit
        character(c_char), intent(in)  :: file(*)
        character(c_char), intent(in)  :: action(*)
        integer(c_int)   , intent(in)  :: recl
        character(c_char), intent(in)  :: endian(*)

        integer, parameter :: filelen_max = 256
        character(filelen_max) :: file_cp
        character(16)          :: action_cp
        character(16)          :: endian_cp
        integer :: filelen
        integer :: actlen
        integer :: endianlen
        integer :: i

        if (recl <= 0) then
            write(*,'(A)')    '<ERROR STOP>'
            write(*,'(A,I0)') 'Invalid record length : ', recl
            write(*,'(A)')    'Argument "recl" should be more than 0'
            ERROR STOP
        endif

        filelen   = charlen(file, filelen_max)
        actlen    = charlen(action, 16)
        endianlen = charlen(endian, 16)

        file_cp   = char2f(filelen  , file  )
        action_cp = char2f(actlen   , action)
        endian_cp = char2f(endianlen, endian)

        if (trim(action_cp) == 'read') then
            call isexist(trim(file_cp))  !! IN
        endif

        open(NEWUNIT=unit                  , &
           & FILE   =trim(file_cp)         , &
           & ACTION =trim(action_cp), &
           & FORM   ='UNFORMATTED'         , &
           & ACCESS ='DIRECT'              , &
           & RECL   =recl                  , &
           & CONVERT=trim(endian_cp)  )

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


    function charlen(input, lenmax) result(output)
        character(C_CHAR), intent(in) :: input(*)
        integer          , intent(in) :: lenmax
        integer :: output

        integer :: i

        do i = 1, lenmax
            if (input(i) /= C_NULL_CHAR) then
                cycle
            endif
            output = i - 1
            return
        enddo

        output = lenmax

    end function charlen


    function char2f(input_len, input) result(output)
        integer          , intent(in) :: input_len
        character(C_CHAR), intent(in) :: input(input_len)
        character(input_len) :: output

        integer :: i

        output = ''
        do i = 1, input_len
            output(i:i) = input(i)
        enddo

    end function char2f


    subroutine isexist(file)
        character(*), intent(in) :: file
        logical :: check

        INQUIRE(FILE =file , &
              & EXIST=check  )

        if (.NOT. check) then
            write(0,'(A)') '<ERROR STOP>'
            write(0,'(A)') 'Specified file does not exist : ' // trim(file)
            ERROR STOP
        endif

    end subroutine isexist


end module binio

