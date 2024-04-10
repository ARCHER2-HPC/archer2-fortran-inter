# Arrays as arguments

This section describes use of arrays as actual and dummy arguments,
and some associated conditions on their use.

## Functions and subroutine arguments

A number of the following features _require_ that procedure interfaces
be explicit. As we recommend procedures are always placed in modules, we
will assume this is always the case unless otherwise stated.

### Explicit shape

An array may be passed explicitly with information on its shape
as part of the dummy argument list:
```fortran
  subroutine array_operation(nmax, a)

    integer, intent(in) :: nmax
    real,    intent(in) :: a(nmax)
```
This is ok; for large rank objects this can become a little verbose.
The shapes of actual and dummy arguments must agree.

### Assumed shape arguments

As an array in Fortran is a self-describing object, there is the option to
use _assumed shape_:
```fortran
  subroutine array_operation(a)

    real, intent(in) :: a(:)
```
The size of the dummy argument can be recovered via `size()` etc. Note that
it is the _shape_ that is passed, not the bounds; this can lead to errors
without some care. Consider:
```fortran
   real :: a(0:nmax)

   call array_operation(a)
```
The dummy argument in this case would have a size `nmax + 1` and a default
lower bound of `1`. This may not be what is expected.

### Example (2 minutes)

As a simple illustration of this problem, the following example should print out
the values `0,0, 1.0, ...` (not `1.0, 2.0, ...`):
```fortran
$ ftn example1.f90
```
What needs to be done to correct the situation (and we want to keep
the declaration `a(0:3)`)? Correct the program.

Bonus question: why do we need the optional argument `dim` in the `lbound()`
and `ubound()` invocations in the subroutine?

### Automatic objects

A procedure may allocate space for temporary objects which come into
existence when the procedure is invoked, e.g.:
```fortran
  subroutine array_operation(a)

    real, intent(in) :: a
    real             :: tmp(1:size(a))    ! temporary storage
```
Such a temporary array, for which the size may not be known at compile time,
is referred to as an _automatic data object_ and is
likely to be allocated on the stack. It will have a lifetime of the
execution of the procedure. Automatic data objects cannot have an initial
value as part of their declaration.

However, it is generally considered poor software engineering practice to
put large objects on the stack. Heap storage may be preferred.

### Assumed size arrays

Older code may contain the following syntax:
```fortran
  subroutine array_operation(a)

    real :: a(*)
```
The `*` denotes an _assumed size_ array (distinct from assumed shape).
This is something more akin to the plain C pass-by-reference: a pointer.
However, it is potentially error-prone as it does not provide access to
shape information of the associated actual argument.

Prefer the explicit shape, assumed shape, or allocatable options of
Modern Fortran.

## Allocatable arguments

Arguments to procedures may have the `allocatable` attribute.
```fortran
  subroutine array_example(a)

     real, allocatable, intent(inout) :: a(:)
```
The procedure will receive the allocation status of the object on
entry. A number of conditions apply:

1. The corresponding actual argument must also be allocatable.
2. The rank must be specified.
3. Action changing the allocation status of the actual argument
   must occur via the dummy argument.

Well-written procedures may need to check the allocation status of any
allocatable arguments with `allocated()` before action is taken.

### Intent

The intent concerns both the allocation status of the dummy argument as
well as the data.
Dummy arguments with the `allocatable` attribute should follow these rules:

1. An argument with `intent(in)` may not be allocated or deallocated (and
the values may not be altered as for a normal `intent(in)` argument).
2. An argument with `intent(out)` is automatically deallocated on entry if
   already allocated.

The second point may cause some surprises. An intent of `inout` must be
used if any information from the actual argument is to be visible in
the procedure.

### Functions returning allocatable arrays

One can write a function having an allocatable result, e.g.,
```fortran
  function my_allocation(nlen) result(a)

     integer, intent(in)  :: nlen
     integer, allocatable :: a(:)

     allocate(a(nlen))

  end my_allocation
```
The result must be allocated at the point of return.

## Array sections as arguments

We may pass an array section as an actual argument. Consider:
```fortran
  subroutine my_array_operation(a)

    real, intent(inout) :: a(:)

    ! ... some operation on all elements...

  end subroutine my_array_operation
```
We may invoke this as
```fortran
   real :: a(5) = [ 1.0, 2.0, 3.0, 4.0, 5.0 ]

   call my_array_operation(a(1:5:2))
```
to operate on the odd-indexed elements. How has this worked? In practice,
the compiler has probably made a temporary copy of the section as a
contiguous array (with three elements). The copy is passed to the
subroutine, and the result copied out again. The relevant values are
then set in the original array `a(1:5)`. The temporary array is destroyed.

This process is usually referred to as "copy-in, copy-out". In Fortran, the
compiler is given the freedom to do this if it is deemed appropriate. So
Fortran cannot be described as "call by reference" or "call by value". The
standard only says the mechanism "is usually similar to call by reference".

### Example (1 minute)

If you wish to convince yourself of this, a version of this code has been
provided:
```bash
$ ftn example2.f90
```
A `print` statement has been added to the subroutine to confirm that the
dummy argument is an entity of size `3`.

## Exercise (4 minutes)

Write a short example along the lines of `example2.f90` to check that an
allocatable dummy argument with intent `out` is indeed deallocated on
entry to the subroutine.

Can an array section be passed to a subroutine where the corresponding
dummy argument has been declared allocatable?

What happens if a function with an allocatable result returns which the
result in an unallocated state?


