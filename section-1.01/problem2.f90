program problem2

  implicit none

  ! Initialise t(1:3) to the initial values 10, 20, 40

  real :: t(3) = [ (2.0*(i**2 + 1), i = 1,3) ]

  print *, "Initial values ", t(1:3)

end program problem2
