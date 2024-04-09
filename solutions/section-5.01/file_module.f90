module file_module

  implicit none
  public

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

  ! Factory method

  interface
    module function file_writer_from_string(str) result(fp)
      character (len = *), intent(in) :: str
      class (file_writer_t), pointer  :: fp
    end function file_writer_from_string
  end interface

end module file_module
