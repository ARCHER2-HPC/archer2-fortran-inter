program problem1

  implicit none

  ! Use an array constructor to assign elements to values 1.0, 2.0, 3.0

  real, allocatable :: a(:)

  a(:) = [ 1.0, 2.0, 3.0 ]

  print *, "Status ", allocated(a)
  print *, "Values ", a(:)

end program problem1
