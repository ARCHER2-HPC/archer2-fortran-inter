module example2

  ! An example of an ambiguous interface. (Compile only required. No link.)
  ! How can the situation be resolved?
  public

  interface my_print
    module procedure my_print_a, my_print_b
  end interface my_print

contains

  subroutine my_print_a(a, i)

    real,    intent(in) :: a
    integer, intent(in) :: i

    print *, "real32 integer ", a, i

  end subroutine my_print_a

  subroutine my_print_b(i, a)

    integer, intent(in) :: i
    real,    intent(in) :: a

    print *, "integer real32 ", i, a

  end subroutine my_print_b

end module example2
