module my_array_type

  implicit none
  public

  type, public :: my_array_t
    integer           :: nlen = 0
    real, allocatable :: values(:)
  end type my_array_t

  type, public :: my_array_pointer_t
     integer       :: nlen = 0
     real, pointer :: values(:)
  end type my_array_pointer_t

  interface assignment (=)
    module procedure my_assignment
  end interface assignment (=)

contains

  function my_array_allocate(nlen) result(a)

    integer, intent(in) :: nlen
    type (my_array_t)   :: a
    integer             :: i

    a%nlen = nlen
    a%values = [ (1.0*i, i = 1, nlen) ]

  end function my_array_allocate

  !----------------------------------------------------------------------------

  subroutine my_array_destroy(a)

    type (my_array_t), intent(inout) :: a

    a%nlen = 0
    if (allocated(a%values)) deallocate(a%values)

  end subroutine my_array_destroy

  !----------------------------------------------------------------------------

  subroutine my_assignment(a, b)

    type (my_array_pointer_t), intent(out) :: a
    type (my_array_t), target, intent(in)  :: b

    a%nlen = b%nlen
    a%values => b%values

  end subroutine my_assignment

end module my_array_type
