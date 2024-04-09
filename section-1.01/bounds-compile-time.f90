program bounds_check1

  ! Compile time error
  implicit none
  real :: array(3)

  print *, "First array element ", array(0)

end program bounds_check1
