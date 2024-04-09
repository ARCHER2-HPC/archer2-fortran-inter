program test1

  use object_type
  implicit none

  type (object_t), target :: obj
  type (sphere_t), target :: s
  real            :: rho = 1.0
  real            :: x(3) = [ 2.0, 3.0, 4.0 ]
  real            :: radius = 1.5

  class (object_t), pointer :: p => null()

  s = sphere_t(rho, x, radius)

  print *, "Sphere density ", s%object_t%rho
  print *, "Sphere density ", s%rho
  print *, "Sphere radius  ", s%a

  s = sphere_t(a = radius, rho = rho , x = x)

  print *, "Sphere density ", s%object_t%rho
  print *, "Sphere density ", s%rho
  print *, "Sphere radius  ", s%a

  obj = object_t(2.5, [1.0, 1.0, 1.0])
  s   = sphere_t(obj, radius)

  print *, "Sphere density   ", s%rho
  print *, "Sphere position: ", s%x
  print *, "Sphere radius    ", s%a

  print *, "Object volume    ", obj%volume()
  print *, "Sphere volume    ", s%volume()
  print *, "Sphere mass      ", s%mass()

  p => s
  print *, "Sphere volume    ", p%volume()
  print *, "Sphere mass      ", p%mass()
  
end program test1
