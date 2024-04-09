program exmaple1

  use iso_fortran_env
  implicit none

  type :: my_array_t(kr, nlen)
    integer, kind :: kr
    integer, len  :: nlen
    real (kr)     :: data(nlen)
  end type my_array_t

  integer :: kr
  integer :: nlen
  type (my_array_t(kr = real64, nlen = 1000)) :: a

  print *, "kind a", a%kr
  print *, "nlen a", a%nlen

  write (*, "(a)", advance = "no") "kind: "
  read (*, *) kr
  write (*, "(a)", advance = "no") "nlen: "
  read (*, *) nlen

  call defer_me(kr, nlen)

contains

  subroutine defer_me(kr, nlen)

    integer, intent(in) :: kr
    integer, intent(in) :: nlen
    type (my_array_t(kr, nlen)) :: b

    print *, "Defer me ", b%kr
    print *, "Length   ", b%nlen

  end subroutine defer_me

end program exmaple1
