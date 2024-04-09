program example1

  use iso_fortran_env
  implicit none

  real (real32),  target :: r32 = 32.0
  real (real64),  target :: r64 = 64.0
  real (real32), pointer :: p32 => null()
  real (real64), pointer :: p64 => null()

  class (*),     pointer :: p => null()

  p32 => r32
  p32 => r64
  p   => r32
  p   => r64

  p32 = 0.0
  p   = 0.0

  p32 => p

  print *, "Result ", p32, p64
  print *, "Result ", p

end program example1
