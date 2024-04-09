module object_type

  implicit none
  public

  type, public :: object_t
    real :: rho  = 1.0       ! density
    real :: x(3) = 0.0       ! poistion of centre of mass
  contains
    procedure, pass :: volume => object_volume
  end type object_t

  type, extends(object_t), public :: sphere_t
    real :: a = 1.0          ! radius
  contains
    procedure, pass, non_overridable :: volume => sphere_volume
    procedure, pass                  :: mass   => sphere_mass
  end type sphere_t

  type, extends(sphere_t), public :: charged_sphere_t
     real :: q = -1.0         ! charge
  end type charged_sphere_t

contains

  function object_volume(self) result(volume)

    class (object_t), intent(in) :: self
    real                         :: volume

    volume = 0.0

  end function object_volume

  function sphere_volume(self) result(volume)

    class (sphere_t), intent(in) :: self
    real                         :: volume

    volume = (4.0/3.0)*(4.0*atan(1.0))*self%a**3

  end function sphere_volume

  function sphere_mass(self) result(mass)

    class (sphere_t), intent(in) :: self
    real                         :: mass

    mass = self%rho*self%volume()

  end function sphere_mass

end module object_type
