program example1

  use my_semi_opaque_type
  implicit none

  type (my_semi_opaque_t) :: a
  type (my_semi_opaque_t) :: b

  b = my_semi_opaque(2, 3)
  a = b

  call my_semi_opaque_print("a", a)

end program example1
