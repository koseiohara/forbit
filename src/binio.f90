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
    public :: binio_fread_sp1, binio_fread_dp1, &
            & binio_fread_sp2, binio_fread_dp2, &
            & binio_fread_sp3, binio_fread_dp3, &
            & binio_fread_sp4, binio_fread_dp4, &
            & binio_fread_sp5, binio_fread_dp5, &
            & binio_fread_sp6, binio_fread_dp6
    public :: binio_fwrite_sp1, binio_fwrite_dp1, &
            & binio_fwrite_sp2, binio_fwrite_dp2, &
            & binio_fwrite_sp3, binio_fwrite_dp3, &
            & binio_fwrite_sp4, binio_fwrite_dp4, &
            & binio_fwrite_sp5, binio_fwrite_dp5, &
            & binio_fwrite_sp6, binio_fwrite_dp6


    contains


    subroutine binio_fopen(unit, file, action, recl, endian) bind(C)
        use, intrinsic :: iso_fortran_env, only : err=>error_unit
        integer(c_int)      , intent(out) :: unit
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

        if (recl <= 0) then
            write(err,'(A)')    '<ERROR STOP>'
            write(err,'(A,I0)') 'Invalid record length: ', recl
            write(err,'(A)')    'Argument "recl" should be more than 0'
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

        open(NEWUNIT=unit           , &
           & FILE   =trim(file_cp)  , &
           & ACTION =trim(action_cp), &
           & FORM   ='UNFORMATTED'  , &
           & ACCESS ='DIRECT'       , &
           & RECL   =recl           , &
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


    subroutine binio_fread_sp1(unit, n1, record, input_data) bind(C)
        integer(c_int), intent(in)  :: unit
        integer(c_int), intent(in)  :: n1
        integer(c_long_long), intent(in)  :: record
        real(c_float) , intent(out) :: input_data(n1)

        call negative_record(record)
        read(unit,rec=record) input_data(1:n1)

    end subroutine binio_fread_sp1


    subroutine binio_fread_dp1(unit, n1, record, input_data) bind(C)
        integer(c_int), intent(in)  :: unit
        integer(c_int), intent(in)  :: n1
        integer(c_long_long), intent(in)  :: record
        real(c_double), intent(out) :: input_data(n1)

        call negative_record(record)
        read(unit,rec=record) input_data(1:n1)

    end subroutine binio_fread_dp1


    subroutine binio_fread_sp2(unit, n1, n2, record, input_data) bind(C)
        integer(c_int), intent(in)  :: unit
        integer(c_int), intent(in)  :: n1
        integer(c_int), intent(in)  :: n2
        integer(c_long_long), intent(in)  :: record
        real(c_float) , intent(out) :: input_data(n1,n2)

        call negative_record(record)
        read(unit,rec=record) input_data(1:n1,1:n2)

    end subroutine binio_fread_sp2


    subroutine binio_fread_dp2(unit, n1, n2, record, input_data) bind(C)
        integer(c_int), intent(in)  :: unit
        integer(c_int), intent(in)  :: n1
        integer(c_int), intent(in)  :: n2
        integer(c_long_long), intent(in)  :: record
        real(c_double), intent(out) :: input_data(n1,n2)

        call negative_record(record)
        read(unit,rec=record) input_data(1:n1,1:n2)

    end subroutine binio_fread_dp2


    subroutine binio_fread_sp3(unit, n1, n2, n3, record, input_data) bind(C)
        integer(c_int), intent(in)  :: unit
        integer(c_int), intent(in)  :: n1
        integer(c_int), intent(in)  :: n2
        integer(c_int), intent(in)  :: n3
        integer(c_long_long), intent(in)  :: record
        real(c_float) , intent(out) :: input_data(n1,n2,n3)

        call negative_record(record)
        read(unit,rec=record) input_data(1:n1,1:n2,1:n3)

    end subroutine binio_fread_sp3


    subroutine binio_fread_dp3(unit, n1, n2, n3, record, input_data) bind(C)
        integer(c_int), intent(in)  :: unit
        integer(c_int), intent(in)  :: n1
        integer(c_int), intent(in)  :: n2
        integer(c_int), intent(in)  :: n3
        integer(c_long_long), intent(in)  :: record
        real(c_double), intent(out) :: input_data(n1,n2,n3)

        call negative_record(record)
        read(unit,rec=record) input_data(1:n1,1:n2,1:n3)

    end subroutine binio_fread_dp3


    subroutine binio_fread_sp4(unit, n1, n2, n3, n4, record, input_data) bind(C)
        integer(c_int), intent(in)  :: unit
        integer(c_int), intent(in)  :: n1
        integer(c_int), intent(in)  :: n2
        integer(c_int), intent(in)  :: n3
        integer(c_int), intent(in)  :: n4
        integer(c_long_long), intent(in)  :: record
        real(c_float) , intent(out) :: input_data(n1,n2,n3,n4)

        call negative_record(record)
        read(unit,rec=record) input_data(1:n1,1:n2,1:n3,1:n4)

    end subroutine binio_fread_sp4


    subroutine binio_fread_dp4(unit, n1, n2, n3, n4, record, input_data) bind(C)
        integer(c_int), intent(in)  :: unit
        integer(c_int), intent(in)  :: n1
        integer(c_int), intent(in)  :: n2
        integer(c_int), intent(in)  :: n3
        integer(c_int), intent(in)  :: n4
        integer(c_long_long), intent(in)  :: record
        real(c_double), intent(out) :: input_data(n1,n2,n3,n4)

        call negative_record(record)
        read(unit,rec=record) input_data(1:n1,1:n2,1:n3,1:n4)

    end subroutine binio_fread_dp4


    subroutine binio_fread_sp5(unit, n1, n2, n3, n4, n5, record, input_data) bind(C)
        integer(c_int), intent(in)  :: unit
        integer(c_int), intent(in)  :: n1
        integer(c_int), intent(in)  :: n2
        integer(c_int), intent(in)  :: n3
        integer(c_int), intent(in)  :: n4
        integer(c_int), intent(in)  :: n5
        integer(c_long_long), intent(in)  :: record
        real(c_float) , intent(out) :: input_data(n1,n2,n3,n4,n5)

        call negative_record(record)
        read(unit,rec=record) input_data(1:n1,1:n2,1:n3,1:n4,1:n5)

    end subroutine binio_fread_sp5


    subroutine binio_fread_dp5(unit, n1, n2, n3, n4, n5, record, input_data) bind(C)
        integer(c_int), intent(in)  :: unit
        integer(c_int), intent(in)  :: n1
        integer(c_int), intent(in)  :: n2
        integer(c_int), intent(in)  :: n3
        integer(c_int), intent(in)  :: n4
        integer(c_int), intent(in)  :: n5
        integer(c_long_long), intent(in)  :: record
        real(c_double), intent(out) :: input_data(n1,n2,n3,n4,n5)

        call negative_record(record)
        read(unit,rec=record) input_data(1:n1,1:n2,1:n3,1:n4,1:n5)

    end subroutine binio_fread_dp5


    subroutine binio_fread_sp6(unit, n1, n2, n3, n4, n5, n6, record, input_data) bind(C)
        integer(c_int), intent(in)  :: unit
        integer(c_int), intent(in)  :: n1
        integer(c_int), intent(in)  :: n2
        integer(c_int), intent(in)  :: n3
        integer(c_int), intent(in)  :: n4
        integer(c_int), intent(in)  :: n5
        integer(c_int), intent(in)  :: n6
        integer(c_long_long), intent(in)  :: record
        real(c_float) , intent(out) :: input_data(n1,n2,n3,n4,n5,n6)

        call negative_record(record)
        read(unit,rec=record) input_data(1:n1,1:n2,1:n3,1:n4,1:n5,1:n6)

    end subroutine binio_fread_sp6


    subroutine binio_fread_dp6(unit, n1, n2, n3, n4, n5, n6, record, input_data) bind(C)
        integer(c_int), intent(in)  :: unit
        integer(c_int), intent(in)  :: n1
        integer(c_int), intent(in)  :: n2
        integer(c_int), intent(in)  :: n3
        integer(c_int), intent(in)  :: n4
        integer(c_int), intent(in)  :: n5
        integer(c_int), intent(in)  :: n6
        integer(c_long_long), intent(in)  :: record
        real(c_double), intent(out) :: input_data(n1,n2,n3,n4,n5,n6)

        call negative_record(record)
        read(unit,rec=record) input_data(1:n1,1:n2,1:n3,1:n4,1:n5,1:n6)

    end subroutine binio_fread_dp6


    subroutine binio_fwrite_sp1(unit, n1, record, output_data) bind(C)
        integer(c_int), intent(in) :: unit
        integer(c_int), intent(in) :: n1
        integer(c_long_long), intent(in) :: record
        real(c_float) , intent(in) :: output_data(n1)

        call negative_record(record)
        write(unit,rec=record) output_data(1:n1)

    end subroutine binio_fwrite_sp1


    subroutine binio_fwrite_dp1(unit, n1, record, output_data) bind(C)
        integer(c_int), intent(in) :: unit
        integer(c_int), intent(in) :: n1
        integer(c_long_long), intent(in) :: record
        real(c_double), intent(in) :: output_data(1:n1)

        call negative_record(record)
        write(unit,rec=record) output_data(1:n1)

    end subroutine binio_fwrite_dp1


    subroutine binio_fwrite_sp2(unit, n1, n2, record, output_data) bind(C)
        integer(c_int), intent(in) :: unit
        integer(c_int), intent(in) :: n1
        integer(c_int), intent(in) :: n2
        integer(c_long_long), intent(in) :: record
        real(c_float) , intent(in) :: output_data(1:n1,1:n2)

        call negative_record(record)
        write(unit,rec=record) output_data(1:n1,1:n2)

    end subroutine binio_fwrite_sp2


    subroutine binio_fwrite_dp2(unit, n1, n2, record, output_data) bind(C)
        integer(c_int), intent(in) :: unit
        integer(c_int), intent(in) :: n1
        integer(c_int), intent(in) :: n2
        integer(c_long_long), intent(in) :: record
        real(c_double), intent(in) :: output_data(1:n1,1:n2)

        call negative_record(record)
        write(unit,rec=record) output_data(1:n1,1:n2)

    end subroutine binio_fwrite_dp2


    subroutine binio_fwrite_sp3(unit, n1, n2, n3, record, output_data) bind(C)
        integer(c_int), intent(in) :: unit
        integer(c_int), intent(in) :: n1
        integer(c_int), intent(in) :: n2
        integer(c_int), intent(in) :: n3
        integer(c_long_long), intent(in) :: record
        real(c_float) , intent(in) :: output_data(1:n1,1:n2,1:n3)

        call negative_record(record)
        write(unit,rec=record) output_data(1:n1,1:n2,1:n3)

    end subroutine binio_fwrite_sp3


    subroutine binio_fwrite_dp3(unit, n1, n2, n3, record, output_data) bind(C)
        integer(c_int), intent(in) :: unit
        integer(c_int), intent(in) :: n1
        integer(c_int), intent(in) :: n2
        integer(c_int), intent(in) :: n3
        integer(c_long_long), intent(in) :: record
        real(c_double), intent(in) :: output_data(1:n1,1:n2,1:n3)

        call negative_record(record)
        write(unit,rec=record) output_data(1:n1,1:n2,1:n3)

    end subroutine binio_fwrite_dp3


    subroutine binio_fwrite_sp4(unit, n1, n2, n3, n4, record, output_data) bind(C)
        integer(c_int), intent(in) :: unit
        integer(c_int), intent(in) :: n1
        integer(c_int), intent(in) :: n2
        integer(c_int), intent(in) :: n3
        integer(c_int), intent(in) :: n4
        integer(c_long_long), intent(in) :: record
        real(c_float) , intent(in) :: output_data(1:n1,1:n2,1:n3,1:n4)

        call negative_record(record)
        write(unit,rec=record) output_data(1:n1,1:n2,1:n3,1:n4)

    end subroutine binio_fwrite_sp4


    subroutine binio_fwrite_dp4(unit, n1, n2, n3, n4, record, output_data) bind(C)
        integer(c_int), intent(in) :: unit
        integer(c_int), intent(in) :: n1
        integer(c_int), intent(in) :: n2
        integer(c_int), intent(in) :: n3
        integer(c_int), intent(in) :: n4
        integer(c_long_long), intent(in) :: record
        real(c_double), intent(in) :: output_data(1:n1,1:n2,1:n3,1:n4)

        call negative_record(record)
        write(unit,rec=record) output_data(1:n1,1:n2,1:n3,1:n4)

    end subroutine binio_fwrite_dp4


    subroutine binio_fwrite_sp5(unit, n1, n2, n3, n4, n5, record, output_data) bind(C)
        integer(c_int), intent(in) :: unit
        integer(c_int), intent(in) :: n1
        integer(c_int), intent(in) :: n2
        integer(c_int), intent(in) :: n3
        integer(c_int), intent(in) :: n4
        integer(c_int), intent(in) :: n5
        integer(c_long_long), intent(in) :: record
        real(c_float) , intent(in) :: output_data(1:n1,1:n2,1:n3,1:n4,1:n5)

        call negative_record(record)
        write(unit,rec=record) output_data(1:n1,1:n2,1:n3,1:n4,1:n5)

    end subroutine binio_fwrite_sp5


    subroutine binio_fwrite_dp5(unit, n1, n2, n3, n4, n5, record, output_data) bind(C)
        integer(c_int), intent(in) :: unit
        integer(c_int), intent(in) :: n1
        integer(c_int), intent(in) :: n2
        integer(c_int), intent(in) :: n3
        integer(c_int), intent(in) :: n4
        integer(c_int), intent(in) :: n5
        integer(c_long_long), intent(in) :: record
        real(c_double), intent(in) :: output_data(1:n1,1:n2,1:n3,1:n4,1:n5)

        call negative_record(record)
        write(unit,rec=record) output_data(1:n1,1:n2,1:n3,1:n4,1:n5)

    end subroutine binio_fwrite_dp5


    subroutine binio_fwrite_sp6(unit, n1, n2, n3, n4, n5, n6, record, output_data) bind(C)
        integer(c_int), intent(in) :: unit
        integer(c_int), intent(in) :: n1
        integer(c_int), intent(in) :: n2
        integer(c_int), intent(in) :: n3
        integer(c_int), intent(in) :: n4
        integer(c_int), intent(in) :: n5
        integer(c_int), intent(in) :: n6
        integer(c_long_long), intent(in) :: record
        real(c_float) , intent(in) :: output_data(1:n1,1:n2,1:n3,1:n4,1:n5,1:n6)

        call negative_record(record)
        write(unit,rec=record) output_data(1:n1,1:n2,1:n3,1:n4,1:n5,1:n6)

    end subroutine binio_fwrite_sp6


    subroutine binio_fwrite_dp6(unit, n1, n2, n3, n4, n5, n6, record, output_data) bind(C)
        integer(c_int), intent(in) :: unit
        integer(c_int), intent(in) :: n1
        integer(c_int), intent(in) :: n2
        integer(c_int), intent(in) :: n3
        integer(c_int), intent(in) :: n4
        integer(c_int), intent(in) :: n5
        integer(c_int), intent(in) :: n6
        integer(c_long_long), intent(in) :: record
        real(c_double), intent(in) :: output_data(1:n1,1:n2,1:n3,1:n4,1:n5,1:n6)

        call negative_record(record)
        write(unit,rec=record) output_data(1:n1,1:n2,1:n3,1:n4,1:n5,1:n6)

    end subroutine binio_fwrite_dp6


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

