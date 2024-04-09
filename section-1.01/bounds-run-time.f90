program bounds_check1

  ! Run time error
  implicit none

  real    :: array(3)
  integer :: i

  write (*, '(a)', advance = 'no') "Input an array index "
  read (*, *) i

  print *, "First array element ", array(i)

end program bounds_check1
