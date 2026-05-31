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
    public :: binio_fread_sp , binio_fread_dp
    public :: binio_fwrite_sp, binio_fwrite_dp


    contains


    subroutine binio_fopen(unit, stat, file, action, recl, endian) bind(C)
        use, intrinsic :: iso_fortran_env, only : err=>error_unit
        integer(c_int)      , intent(out) :: unit
        integer(c_int)      , intent(out) :: stat
        character(c_char)   , intent(in)  :: file(*)
        character(c_char)   , intent(in)  :: action(*)
        integer(c_long_long), intent(in)  :: recl
        character(c_char)   , intent(in)  :: endian(*)

        integer, parameter :: filelen_max = 256
        character(filelen_max) :: file_cp
        character(16)          :: action_cp
        character(16)          :: endian_cp
        integer :: filelen
        integer :: actlen
        integer :: endianlen
        integer :: i
        logical :: exist

        ! if (recl <= 0) then
        !     write(err,'(A)')    '<ERROR STOP>'
        !     write(err,'(A,I0)') 'Invalid record length: ', recl
        !     write(err,'(A)')    'Argument "recl" should be more than 0'
        !     ERROR STOP
        ! endif

        stat = 0

        filelen   = charlen(file, filelen_max)
        actlen    = charlen(action, 16)
        endianlen = charlen(endian, 16)

        file_cp   = char2f(filelen  , file  )
        action_cp = char2f(actlen   , action)
        endian_cp = char2f(endianlen, endian)

        if (trim(action_cp) == 'read') then
            inquire(file =trim(file_cp), &  !! IN
                  & exist=exist          )  !! OUT

            if (.NOT. exist) then
                stat = -1
                return
            endif
        endif

        ! if (trim(action_cp) == 'read') then
        !     call isexist(trim(file_cp))  !! IN
        ! endif

        open(NEWUNIT=unit           , &
           & FILE   =trim(file_cp)  , &
           & ACTION =trim(action_cp), &
           & FORM   ='UNFORMATTED'  , &
           & ACCESS ='DIRECT'       , &
           & RECL   =recl           , &
           & CONVERT=trim(endian_cp), &
           & IOSTAT =stat             )

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


    subroutine binio_fread_sp(unit, n, record, input_data, stat) bind(C)
        integer(c_int), intent(in)  :: unit
        integer(c_long_long), intent(in)  :: n
        integer(c_long_long), intent(in)  :: record
        real(c_float) , intent(out) :: input_data(n)
        integer(c_int), intent(out) :: stat

        ! call negative_record(record)
        read(unit,rec=record,iostat=stat) input_data(1:n)

    end subroutine binio_fread_sp


    subroutine binio_fread_dp(unit, n, record, input_data, stat) bind(C)
        integer(c_int), intent(in)  :: unit
        integer(c_long_long), intent(in)  :: n
        integer(c_long_long), intent(in)  :: record
        real(c_double), intent(out) :: input_data(n)
        integer(c_int), intent(out) :: stat

        ! call negative_record(record)
        read(unit,rec=record,iostat=stat) input_data(1:n)

    end subroutine binio_fread_dp


    subroutine binio_fwrite_sp(unit, n, record, output_data, stat) bind(C)
        integer(c_int), intent(in) :: unit
        integer(c_long_long), intent(in) :: n
        integer(c_long_long), intent(in) :: record
        real(c_float) , intent(in) :: output_data(n)
        integer(c_int), intent(out) :: stat

        ! call negative_record(record)
        write(unit,rec=record,iostat=stat) output_data(1:n)

    end subroutine binio_fwrite_sp


    subroutine binio_fwrite_dp(unit, n, record, output_data, stat) bind(C)
        integer(c_int), intent(in) :: unit
        integer(c_long_long), intent(in) :: n
        integer(c_long_long), intent(in) :: record
        real(c_double), intent(in) :: output_data(1:n)
        integer(c_int), intent(out) :: stat

        ! call negative_record(record)
        write(unit,rec=record,iostat=stat) output_data(1:n)

    end subroutine binio_fwrite_dp


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
        use, intrinsic :: iso_fortran_env, only : err=>error_unit
        character(*), intent(in) :: file
        logical :: check

        INQUIRE(FILE =file , &
              & EXIST=check  )

        if (.NOT. check) then
            write(err,'(A)') '<ERROR STOP>'
            write(err,'(A)') 'Specified file does not exist : ' // trim(file)
            ERROR STOP
        endif

    end subroutine isexist


    subroutine negative_record(record)
        use, intrinsic :: iso_fortran_env, only : err=>error_unit
        integer(c_long_long), intent(in) :: record

        if (record <= 0) then
            write(err,'(A)') '<ERROR STOP>'
            write(err,'(A,I0,A)') 'Record must be a positive value, but ', record, ' was specified'
            ERROR STOP
        endif

    end subroutine negative_record

end module binio

