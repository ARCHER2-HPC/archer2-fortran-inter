# Derived types

Derived types provide the fundamental basis for data structures (cf. `struct` in
C++). Derived types are sometimes referred to as user-defined types. The
advice given in the introductory course was always to place type
definitions in a module.

## Definition

We recall that the general form of the declaration is:
```
 type [ [, attribute-list] :: ] type-name
    [private]
    component-part
  [ contains
    procedure-part ]
  end type [ type-name ]
```
Compoenents types may be intrinsic, allocatable, pointer, or other derived
types. The procedure part is used (optionally) to define so-called
_type-bound procedures_. These are the equivalent of class methods in other
languages (and will be covered in detail in later Sections). Scope of
components may be controlled via `public` or `private` statements.

Encapsulation may be achieved by declaring a `public` type with `private`
components, e.g.,
```
type, public :: my_opaque_t
  private
  integer :: idata
end type my_opaque_t
```
It is also possible to have a mixture, e.g.:
```
type, public :: my_semi_opaque_t
  private
  integer         :: idata   ! default private
  integer, public :: ndata   ! explicitly public
end type my_semi_opaque_t
```

Components are referenced using the component selector `%`. Types with
components which are themselves derived types give rise to the idea of
an _ultimate component_, which is an intrinsic type for which no further
application of `%` is relevant.

### `protected` attribute

Note that there is a `protected` attribute in Fortran, although it has
a slightly different usage than in C++. It will be discussed later as
part of the section on submodules.
Some authors argue that `protected` should be avoided as it represents
a breakdown of encapsulation.

## Assignments and copying

### Intrinsic assignments

Intrinsic assignment is available for types, and just involves an
intrinsic assignment of each component in turn. Schemetically:
```
  type (my_semi_opaque_t) :: a
  type (my_semi_opaque_t) :: b

  b = my_semi_opaque(2, 3)
  a = b
```
Here, the components of `a` will take on the values of the components of `b`.

If a type component is itself a derived type, then intrinsic assignment takes
place in the same way for that component.

#### Example (4 minutes)

The accompanying module `my_semi_opaque_type.f90` provides a public definition
of the type as defined above, and includes a function to initialise the two
components. The accompanying program `exercise1.f90` will make the intrinsic
assignment. You can compile with, e.g.,
```
$ ftn my_semi_opaque_type.f90 example1.f90
```
How are you going to check that the result of the assignment is correct for
_both_ components (by printing the result to the screen)? Write some code to
perform this check.

### Allocatable components

Suppose our derived type had an allocatable component. For example:
```
  type, public :: my_array_t
    integer           :: nlen
    real, allocatable :: values(:)
  end type my_array_t
```
Intrinsic assignment takes place for such an object in much the
same way, e.g.,
```
  type (my_array_t) :: a
  type (my_array_t) :: b

  ! ... establish some data for b ...

  a = b
```
However, there are a number of extra steps involved: 1) if the `values`
component of `a` on the left hand side is already allocated, it is
first deallocated; 2) an appropriate allocation is then made for `a`
depending on the size and bounds of `b%values(:)`; 3) all the relevant
values of the right-hand side are copied to the left-hand side.

If `b%values` is unallocated, then step (2) is omitted, and `a%values`
is also unallocated after assignment.

This is, in the jargon, a _deep copy_. You have a copy of the actual data.

Again, this process is repeated until any ultimate allocatable component
is reached.

### Pointer components

For types with pointer components, the situation is different. Consider:
```
  type, public :: my_array_pointer_t
    integer       :: nlen
    real, pointer :: values(:)
  end type my_array_pointer_t
```
Assignment here means that the pointer becomes associated with the
target on the right-hand side.
```
  type (my_array_pointer_t) :: a
  type (my_array_pointer_t) :: b

  b%nlen = 10
  allocate(b%values(b%nlen))
  a = b
```
This implies that if, in a subsequent step, the target becomes
unassociated (or deallocated), then the reference retained in
`a` is in a bad state.

This is a _shallow copy_. No data have been duplicated; only the
pointer description itself.

#### Example (2 minutes)

In the accompanying module `my_array_type.f90` both the types above
have been declared, along with a function to initialise some array
values. Compile the example program:
```
$ ftn my_array_type.f90 example2.f90
```
and check the values printed out. What happens if you insert a
call to `my_array_destroy(a)` (which deallocates the values
assoviated with the `my_array_t` argument) at the end of the
program and try to print the values of the pointer type `c`
again?

What happens if you try to make a direct assignment between a
`my_array_t` object on the right-hand side, and a `my_array_pointer_t`
on the left-hand side?

## A defined assignment

If something other than intrinsic assignment for types is required, it is
possible to overload the meaning of the assignment operation `=`.

For example, if an assignment between two objects of `my_array_t` were
required, one could write, as part of a module:
```
  subroutine my_assignment(a, b)

    type (my_array_t), intent(out) :: a
    type (my_array_t), intent(in)  :: b

    a%nlen = b%nlen
    a%values = b%values

  end subroutine my_assignment

  interface assignment (=)
    module procedure my_assignment
  end interface assignment (=)
```
This must be a subroutine with two arguments, the first with `intent(out)`
(or `inout`) to represent the left-hand side of the assignment, and the
second with `intent(in)` to represeent the right-hand side.

### Exercise (4 minutes)

In `example2.f90` we explcitly assigned both components of the `my_array_pointer_t`
in the code and found we could not make an assignment between `my_array_pointer_t`
and `my_array_t`. Add a subroutine in `my_array_type.f90` to make this possible.
