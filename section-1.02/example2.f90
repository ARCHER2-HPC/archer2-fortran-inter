program example2

  implicit none

  real :: a(5) = [ 1.0, 2.0, 3.0, 4.0, 5.0 ]

  call my_array_operation(a(1:5:2))
  print "(a,5(1x,f5.2))", "Final values ", a(1:5)

contains

  subroutine my_array_operation(b)

    real, intent(inout) :: b(:)

    print *, "shape(b): ", shape(b)

    b(:) = 0.0

  end subroutine my_array_operation

end program example2
