# Type extension and polymorphism

Type extension and polymorphism provide the ability to define a uniform
interface which can be used to interact with different implementations,
and also handle references to such objects in a uniform way. This is the
basis for abstraction.

## Extending an existing type

Suppose we had a type to represent a general category of entity
or object, e.g.,
```
type, public :: object_t
  real :: rho           ! density
  real :: x(3)          ! position of centre of mass
end type base_t
```
We can now define a more specific entity by extending the `object_t`,
e.g.,
```
type, extends(object_t), public :: sphere_t
  real :: a             ! radius
end type sphere_t
```
This new type is said to inherit the components of the original type
which may be accessed via the component selector in one of two ways:
```
  type (sphere_t) :: s
  real            :: density

  density = s%object_t%rho
  density = s%rho
```
The two assignments are equivalent. The new type has a _parent_ component
which has the name of the original, or base, type.

For operations which treat the base type as a whole, the longer form
may be useful. However, if just component access is required, the
second, shorter, form is more concise and to be preferred.

A new type may extend only one existing type in Fortran:
it has a so-called _single inheritance_ model.


### Structure constructors

There is a default structure constructor associated with the new type
```
  type (sphere_t) :: s
  real            :: rho = 1.0
  real            :: x(3) = [ 2.0, 3.0, 4.0 ]
  real            :: radius = 1.5

  s = sphere_t(rho, x, radius)
```
The order for the components in the structure constructor is the base
type components first, and then the extended type components second.
The components of each type also appear in the order that they have
been declared.

The order can be adjusted with the use of keywords, e.g.:
```
  s = sphere_t(a = radius, rho = rho, x = x)
```
We may also use the base type as a component of the structure constructor
```
  type (object_t) :: obj
  type (sphere_t) :: s
  real            :: a = 2.5

  obj = object_t(1.5, [1.0, 1.0, 1.0])
  s   = sphere_t(object_t = obj, a)
```
Keywords are not necessary unless the order of the arguments is
other than the defined order. Recall that components with default
initialisations may be omitted in the structure constructor.

New types can be further extended by following the same procedure.

### Example (4 minutes)

Further extend the `sphere_t` to give a `charged_sphere_t` by adding
a (`real`) component `q` in the new type. The first two type
definitions are provided in the file `object_type.f90`.

In the example main program, check you can provide some value for the
new charge component via a constructor (e.g., `q = -1.0`), and access
the charge component of the new type in both long and short forms.
```
$ ftn example1.f90 object_type.f90
```


## Polymorphism

In order to be able to handle types and extended types in a flexible way,
we need a mechanism that allows a given variable to reference
objects of different type. Such a variable is typically a pointer
in many languages.

Fortran provides the pointer mechanism using
```
  class (object_t), pointer :: obj => null()
```
One may also have an allocatable polymorphic object:
```
  class (object_t), allocatable :: obj
```
A class pointer cannot be declared as being of an
intrinsic type: the object must be an extensible derived type.

The `class` declaration is a signal that we intend to use this variable
in a polymorphic context. We will consider just the pointer alternative
for the time being.


### Declared and dynamic type

The declaration
```
  class (object_t), pointer :: obj => null()
```
allows the pointer `obj` to be associated with a target which has a type
`object_t` or any other type which extends `object_t`. The pointer is
said to be _type-compatible_ with this class of objects.

In the above example, the _declared_ type of the polymorphic pointer is
`object_t`. The declared type does not change.

The _dynamic_ type may be changed by associating the pointer with a
target of an extended type, e.g. with:
```
  class (object_t), pointer :: obj => null()
  type (sphere_t),  target  :: s

  obj => s
```
the dynamic type would become `sphere_t`. The dynamic type of an
unassociated pointer is its declared type.

The polymorphic variable has access to components
of only of the declared type, but not of its descendents. So
```
  class (object_t), pointer :: obj => null()
  type (sphere_t),  target  :: s

  obj => s
  obj%rho      ! ok: rho is a component of the declared type
  obj%a        ! erroneous: radius `a` is component of the extended type
```

Dynamic type will also be relevant when procedures are considered:
polymorhic dummy arguments take on the dynamic type of the associated
actual argument.


### Exercise (2 minutes)

Compile the second example together with your updated `object_type.f90`
which includes a `charged_sphere_t`:
```
$ ftn example2.f90 object_type.f90
```
(or use the canned solution `object_types.f90`).

Comment out (don't remove for the time being) the erroneous statements
from the example so it will compile.

Why can't we just declare the pointer to be:
```
 class (charged_sphere_t), pointer :: p
```
in this example? What is the compiler error if you try?


### Type selection

Code may detect the dynamic type of a polymorphic variable via use
of the `select type` construct, which allows appropriate action to
to taken depending on the dynamic type. This is similar to the
simple `select case` construct, where the behaviour is controlled
by the dynamic type of the _selector_, here `p`:
```
select type (p)
type is (charged_sphere_t)
  print *, "Charge is ", p%q
class is (sphere_t)
  print *, "Radius is ", p%a
class default
  print *, "bare object_t"
end select
```
The are two forms of the so-called type guard statement: `type is` and
`class is`. They may be combined in a single construct. The result depends
on the following logic:
1. if the dynamic type of the selector exactly matches a `type is` block,
then that block is executed;
2. otherwise, if the dynamic type matches a `class is` block (i.e., it
matches that type or a descendant) the `class is` block is executed;
3. otherwise, the `default` block is executed (if present).

So at most one block is executed for any given selector.

### Type inquiry functions

There are a number of intrinsic type inquiry functions which take
polymorphic arguments, and return a logical result depending on
dynamic type.
```
  extends_type_of(a, b)
```
returns `.true.` if the dynamic type of `a` is an extension of `b`;
and
```
  same_type_as(a, b)
```
returns `.true.` if the dynamic types of both arguments are equal.


### Exercise (5 minutes)

Write a subroutine in `object_type.f90` which takes a single polymorphic
argument of `object_t`, and prints out all the relevant components
depending on the dynamic type of the actual argument.

Check your subroutine works by passing each different type in turn from
the `example2.f90` program.


### Exercise (optional)

Type constructors again. Write some generic constructors for object types
which take different data types as arguments. For example, it might be a
convenience to be able to specify the position as a three-vector of integers.
