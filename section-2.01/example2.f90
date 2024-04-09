program example2

  use my_array_type
  implicit none

  type (my_array_t), target :: a
  type (my_array_t)         :: b
  type (my_array_pointer_t) :: c

  b = my_array_allocate(3)
  a = b

  print *, "State of a ", a%nlen, allocated(a%values)

  c%nlen = a%nlen
  c%values => a%values

  print *, "State of c ", c%nlen, associated(c%values), c%values

  call my_array_destroy(a)

  print *, "State of c ", c%nlen, associated(c%values), c%values

end program example2
