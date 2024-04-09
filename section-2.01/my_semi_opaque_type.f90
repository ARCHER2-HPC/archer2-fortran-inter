module my_semi_opaque_type

  ! An example dervided type

  implicit none
  public

  type, public :: my_semi_opaque_t
    private
    integer         :: idata
    integer, public :: ndata
  end type my_semi_opaque_t

contains

  function my_semi_opaque(idata, ndata) result(res)

    integer, intent(in)     :: idata
    integer, intent(in)     :: ndata
    type (my_semi_opaque_t) :: res

    res%idata = idata
    res%ndata = ndata

  end function my_semi_opaque

  !----------------------------------------------------------------------------

  subroutine my_semi_opaque_print(label, a)

    character (len = *),     intent(in) :: label
    type (my_semi_opaque_t), intent(in) :: a

    print *, "(var, idata, ndata): ", label, a%idata, a%ndata

  end subroutine my_semi_opaque_print

end module my_semi_opaque_type
