module BinIO

    use iso_c_binding

    implicit none

    private
    public :: finfo, fopen, fclose, fread_sp, fread_dp, fwrite_sp, fwrite_dp, get_record, reset_record

    type, bind(C) ::  finfo
        private
        integer        :: unit
        character(128) :: file
        character(16)  :: action
        integer        :: nx
        integer        :: ny
        integer        :: nz
        integer        :: record
        integer        :: recl
        integer        :: recstep
    end type finfo


    contains


    function fopen(file, action, record, nx, ny, nz, recl, recstep) result(ftype) bind(C)
        character(*), intent(in) :: file
        character(*), intent(in) :: action
        integer     , intent(in) :: record
        integer     , intent(in) :: nx
        integer     , intent(in) :: ny
        integer     , intent(in) :: nz
        integer     , intent(in) :: recl
        integer     , intent(in) :: recstep

        type(finfo) :: ftype

        if (record <= 0) then
            write(*,'(A)') 'ERROR STOP'
            write(*,'(A,I0)') 'Invalid initial record : ', record
            write(*,'(A)') 'Argument "record" should be more than 0'
            ERROR STOP
        endif

        if (nx <= 0) then
            write(*,'(A)') 'ERROR STOP'
            write(*,'(A,I0)') 'Invalid Grid Size : NX=', nx
            write(*,'(A)') 'Argument "nx" should be more than 0'
            ERROR STOP
        endif

        if (ny <= 0) then
            write(*,'(A)') 'ERROR STOP'
            write(*,'(A,I0)') 'Invalid Grid Size : NY=', ny
            write(*,'(A)') 'Argument "ny" should be more than 0'
            ERROR STOP
        endif

        if (nz <= 0) then
            write(*,'(A)') 'ERROR STOP'
            write(*,'(A,I0)') 'Invalid Grid Size : NZ=', nz
            write(*,'(A)') 'Argument "nz" should be more than 0'
            ERROR STOP
        endif

        if (recl <= 0) then
            write(*,'(A)') 'ERROR STOP'
            write(*,'(A,I0)') 'Invalid record length : ', recl
            write(*,'(A)') 'Argument "recl" should be more than 0'
            ERROR STOP
        endif

        open(NEWUNIT=ftype%unit   , &
           & FILE   =file         , &
           & ACTION =action       , &
           & FORM   ='UNFORMATTED', &
           & ACCESS ='DIRECT'     , &
           & RECL   =recl           )

        ftype%file    = file
        ftype%action  = action
        ftype%record  = record
        ftype%nx      = nx
        ftype%ny      = ny
        ftype%nz      = nz
        ftype%recl    = recl
        ftype%recstep = recstep

    end function fopen


    subroutine fclose(ftype) bind(C)
        type(finfo), intent(inout) :: ftype
        logical :: open_status

        INQUIRE(ftype%unit      , &  !! IN
              & OPENED=open_status)  !! OUT

        if (open_status) then
            close(ftype%unit)
            
            ftype%unit    = 0
            ftype%file    = 'ERROR'
            ftype%action  = 'ERROR'
            ftype%record  = -999
            ftype%recl    = -999
            ftype%recstep = -999

            return
        else
            return
        endif

    end subroutine fclose


    function fread_sp(ftype) result(input_data) bind(C)
        type(finfo), intent(inout) :: ftype

        real(4) :: input_data(ftype%nx,ftype%ny,ftype%nz)

        read(ftype%unit,rec=ftype%record) input_data(1:ftype%nx,1:ftype%ny,1:ftype%nz)
        ftype%record = ftype%record + ftype%recstep

    end function fread_sp


    function fread_dp(ftype) result(input_data) bind(C)
        type(finfo), intent(inout) :: ftype

        real(8) :: input_data(ftype%nx,ftype%ny,ftype%nz)

        read(ftype%unit,rec=ftype%record) input_data(1:ftype%nx,1:ftype%ny,1:ftype%nz)
        ftype%record = ftype%record + ftype%recstep

    end function fread_dp


    subroutine fwrite_sp(ftype, output_data) bind(C)
        type(finfo), intent(inout) :: ftype
        real(4)    , intent(in)    :: output_data(ftype%nx,ftype%ny,ftype%nz)

        write(ftype%unit,rec=ftype%record) output_data(1:ftype%nx,1:ftype%ny,1:ftype%nz)
        ftype%record = ftype%record + ftype%recstep

    end subroutine fwrite_sp


    subroutine fwrite_dp(ftype, output_data) bind(C)
        type(finfo), intent(inout) :: ftype
        real(8)    , intent(in)    :: output_data(ftype%nx,ftype%ny,ftype%nz)

        write(ftype%unit,rec=ftype%record) output_data(1:ftype%nx,1:ftype%ny,1:ftype%nz)
        ftype%record = ftype%record + ftype%recstep

    end subroutine fwrite_dp


    function get_record(ftype) result(record) bind(C)
        type(finfo), intent(in)  :: ftype
        integer :: record

        record = ftype%record

    end function get_record


    subroutine reset_record(ftype, increment, newrecord) bind(C)
        type(finfo), intent(inout) :: ftype
        integer    , intent(in)   , optional :: increment
        integer    , intent(in)   , optional :: newrecord

        if (present(increment)) then
            ftype%record = ftype%record + increment
            return
        else if (present(newrecord)) then
            ftype%record = newrecord
            return
        else
            write(*,'(A)') 'ERROR STOP'
            write(*,'(A)') 'Both "increment" and "newrecord" were not specified in the argument of reset_record()'
            ERROR STOP
        endif

    end subroutine reset_record


end module BinIO

