module object_type

  implicit none
  public

  type, public :: object_t
    real :: rho  = 1.0       ! density
    real :: x(3) = 0.0       ! poistion of centre of mass
  end type object_t

  type, extends(object_t), public :: sphere_t
    real :: a = 1.0          ! radius
  end type sphere_t

  type, extends(sphere_t), public :: charged_sphere_t
    real :: q = -1.0         ! charge
  end type charged_sphere_t

end module object_type
