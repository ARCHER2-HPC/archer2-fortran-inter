program example2

  implicit none

  procedure (integer) :: array_size
  real :: a(13)

  print *, "size of a is: ", array_size(a)

end program example2
