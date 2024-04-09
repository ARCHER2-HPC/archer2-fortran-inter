module file_formatted

  use file_module
  implicit none
  private

  type, extends(file_writer_t), public :: file_formatted_writer_t
    private
    integer :: myunit
  contains
    procedure, pass :: open  => open_formatted
    procedure, pass :: write => write_formatted
    procedure, pass :: close => close_formatted
  end type file_formatted_writer_t

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

end module file_formatted
