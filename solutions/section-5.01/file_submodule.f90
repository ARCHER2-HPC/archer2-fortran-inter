submodule (file_module) file_submodule

  use file_formatted
  use file_unformatted
  implicit none

contains

  function create_file_formatted_writer_t() result(fp)

    class (file_formatted_writer_t), pointer :: fp
    allocate(fp)

  end function create_file_formatted_writer_t

  function create_file_unformatted_writer_t() result(fp)

    class (file_unformatted_writer_t), pointer :: fp
    allocate(fp)

  end function create_file_unformatted_writer_t

  !----------------------------------------------------------------------------

  module function file_writer_from_string(str) result(fp)

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

end submodule file_submodule
