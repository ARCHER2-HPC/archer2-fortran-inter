module file_unformatted

  use file_module
  implicit none
  private

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

  function create_file_unformatted_writer_t() result(fp)

    class (file_unformatted_writer_t), pointer :: fp
    allocate(fp)

  end function create_file_unformatted_writer_t

end module file_unformatted
