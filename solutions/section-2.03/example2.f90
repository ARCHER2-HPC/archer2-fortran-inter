program example2

  use object_type
  implicit none

  type (object_t),         target :: obj = object_t()
  type (sphere_t),         target :: s   = sphere_t()
  type (charged_sphere_t), target :: cs

  class (object_t), pointer       :: p => null()
  ! no can do ...
  !class (charged_sphere_t), pointer       :: p => null()


  obj = object_t(rho = 1.0, x = [1.0, 2.0, 3.0])
  s   = sphere_t(object_t = obj, a = 2.5)
  cs  = charged_sphere_t(sphere_t = s, q = -1.0)

  p => obj

  print *, "object density  ", p%rho
  print *, "object position ", p%x(:)
  !print *, "object radius   ", p%a
  
  p => s

  print *, "sphere density  ", p%rho
  print *, "sphere position ", p%x(:)
  !print *, "sphere radius   ", p%a

  p => s
  !print *, "sphere charge   ", p%q

  print *, "Select type: "
  select type (p)
  class is (object_t)
    print *, "density  ", p%rho
    print *, "position ", p%x(:)
  class is (sphere_t)
    print *, "sphere radius   ", p%a
  class is (charged_sphere_t)
    print *, "sphere charge   ", p%q
  class default
    print *, "unknown"
  end select

end program example2
