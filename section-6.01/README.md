# Type parameters

## Type parameters for intrinsic types

We have seen type parameters (kind type parameters) for intrinsic types:
```
  use iso_fortran_env
  ...
  integer (int32) :: i32
```
This provides a way to control, parametrically, the actual data type
associated with the variable. Such parameters must be known at compile
time.

There are all so-called deferred parameters, such as the length of a
deferred length string
```
  character (len = :), allocatable :: string
```
The colon indicates the length is deferred.


## Parameterised derived types

These features may be combined in a parameterised type definition, e.g.:
```
type, public :: my_array_t(kr, nlen)
  integer, kind :: kr                ! kind parameter
  integer, nlen :: nlen              ! len parameter
  real    (kr)  :: data(nlen)
end type my_array_t
```
The type parameters must be integers and take one of two roles: a `kind`
parameter, which is used in the place of kind type parameters, and a
`len` parameter, which can be used in array bound declaration or a length
specificaition. A `kind` parameter must be a compile-time constant, but a
length parameter may be deferred until run time.

The extra components act as normal components in that they may have a
default value specified in the declaration, and may be accessed at run
time via the component selector `%` in the usual way.

For example declaration of a variable of such a type might look like:
```
  ! ... establish len_input ...

  type (my_array_t(real32, len_input)) :: a
```

Such a parameterised type may have a dummy argument associated with an
actual argument via a dummy argument declaration, e.g.,
```
  type (my_array_t(real32, nlen = *)), intent(in) :: a
```
cf.
```
  character (len = *), intent(in) :: str
```
A pointer declaration of this type would use the deferred notation
with the colon:
```
  type (my_array_t(real32, nlen = :)), pointer p => null()
```
Here, an (optional) keyword has been used in the parameter list.

