module file_module

  implicit none

  type, abstract, public :: file_writer_t
  contains
    procedure (if_open),  pass, deferred :: open
    procedure (if_write), pass, deferred :: write
    procedure (if_close), pass, deferred :: close
  end type file_writer_t

  abstract interface
     function if_open(self, filename) result(ierr)
       import file_writer_t
       class (file_writer_t), intent(inout) :: self
       character (len = *),   intent(in)    :: filename
       integer                              :: ierr
    end function if_open

    function if_write(self, data) result(ierr)
      import file_writer_t
      class (file_writer_t), intent(inout)  :: self
      integer,               intent(in)     :: data(:)
      integer                               :: ierr
    end function if_write

    function if_close(self) result(ierr)
      import file_writer_t
      class (file_writer_t), intent(inout)  :: self
      integer                               :: ierr
    end function if_close
  end interface

  !----------------------------------------------------------------------------

  type, extends(file_writer_t), public :: file_formatted_writer_t
    private
    integer :: myunit
  contains
    procedure, pass :: open  => open_formatted
    procedure, pass :: write => write_formatted
    procedure, pass :: close => close_formatted
 end type file_formatted_writer_t

 !-----------------------------------------------------------------------------

  type, extends(file_writer_t), public :: file_unformatted_writer_t
    private
    integer :: myunit
  contains
    procedure, pass :: open  => open_unformatted
    procedure, pass :: write => write_unformatted
    procedure, pass :: close => close_unformatted
 end type file_unformatted_writer_t


contains

  !----------------------------------------------------------------------------

  function open_formatted(self, filename) result(ierr)

    class (file_formatted_writer_t), intent(inout) :: self
    character (len = *),             intent(in)    :: filename
    integer                                        :: ierr

    open (newunit = self%myunit, file = filename, form = 'formatted', &
         status = "replace", action = 'write', iostat = ierr)

  end function open_formatted

  function write_formatted(self, data) result(ierr)

    class (file_formatted_writer_t), intent(inout) :: self
    integer,                         intent(in)    :: data(:)
    integer                                        :: ierr

    write (unit = self%myunit, fmt = *, iostat = ierr) data(:)

  end function write_formatted

  function close_formatted(self) result(ierr)

    class (file_formatted_writer_t), intent(inout) :: self
    integer                                        :: ierr

    close (unit = self%myunit, status = 'keep', iostat = ierr)

  end function close_formatted

  !----------------------------------------------------------------------------

  function open_unformatted(self, filename) result(ierr)

    class (file_unformatted_writer_t), intent(inout) :: self
    character (len = *),               intent(in)    :: filename
    integer                                          :: ierr

    open (newunit = self%myunit, file = filename, form = 'unformatted', &
         status = "replace", action = 'write', iostat = ierr)

  end function open_unformatted

  function write_unformatted(self, data) result(ierr)

    class (file_unformatted_writer_t), intent(inout) :: self
    integer,                           intent(in)    :: data(:)
    integer                                          :: ierr

    write (unit = self%myunit, iostat = ierr) data(:)

  end function write_unformatted

  function close_unformatted(self) result(ierr)

    class (file_unformatted_writer_t), intent(inout) :: self
    integer                                          :: ierr

    close (unit = self%myunit, status = 'keep', iostat = ierr)

  end function close_unformatted

  !----------------------------------------------------------------------------

  function create_file_formatted_writer_t() result(fp)

    class (file_formatted_writer_t), pointer :: fp
    allocate(fp)

  end function create_file_formatted_writer_t

  function create_file_unformatted_writer_t() result(fp)

    class (file_unformatted_writer_t), pointer :: fp
    allocate(fp)

  end function create_file_unformatted_writer_t


  function file_writer_from_string(str) result(fp)

    character (len = *), intent(in) :: str
    class (file_writer_t), pointer  :: fp

    ! We haven't reached typed allocation yet, hence the extra
    ! routines to return a pointer of the right type.
    fp => null()
    select case (str)
    case ("formatted")
      fp => create_file_formatted_writer_t()
    case ("unformatted")
      fp => create_file_unformatted_writer_t()
    case default
      print *, "Not recognised ", str
    end select

  end function file_writer_from_string

end module file_module
