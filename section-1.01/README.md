# Arrays

## Declarations

We may declare arrays of intrinsic type with a fairly elastic syntax, e.g.:
```fortran
  integer, dimension(10, 2) :: a
  integer, dimension(10, 2) :: b, c, d, e(10, 3)
```
One may also omit the `dimension` attribute:
```fortran
  integer, dimension(10, 2) :: a
  integer                   :: b(10, 2)
```
The two declarations of `b(10,2)` above are equivalent. If one restricts
oneself to one variable
declaration per line, then the second form is more concise, and will
be preferred in the rest of this course.

Arrays have a rank, a size (the number of elements). The sequence of
extents in each dimension is the shape. The array in Fortran is a
self-describing object and its properties may be interrogated via
intrinsic functions: `size()`, `shape()`, `lbound()`, and `ubound()`.

There is an _array element order_ which has the left-most index counting
fastest; we expect this to correspond to contiguous locations in memory.

There are a number of ways one may obtain array sections or array-valued
objects which may not be contiguous:
```fortran
  integer :: a(5)
  real    :: b(10, 2)

  a(1:5:2)          ! an array section   referencing elements 1, 3, and 5
  a( [1, 3, 5] )    ! a vector subscript referencing elements 1, 3, and 5
  b(1:5, 1)         ! a rank one section of size 5
  b(1:2, 1:2)       ! a rank two section of shape (2, 2)
```

### Limit on number of ranks

Arrays of rank up to 7 were supported (pre-F2008); this was increased to
a limit of 15 at F2008. F2018 introduced an intrinsic `rank()` inquiry
function which returns the scaler integer rank of the array argument.


## Array constructors

There are a number of ways to provide initial values for array elements:
```fortran
  integer, parameter :: j(3) = (/ -1, 0, +1 /)    ! F2003
  integer, parameter :: k(3) = [  -1, 0, +1 ]     ! F2008
```
One may also use an _implied do_ construction:
```fortran
  integer         :: i
  real, parameter :: s(300) = [ (i, i = 1,300) ]
  real            :: t(3)   = [ (2.0*(i*i + 1), i = 1,3) ]
```
Older code may also see use of the `data` statement to initialise tables
of values. This has the form:
```
data data-statement-set [[,] data-statement-set] ...
```
where the `data-statement-set` consists of pairs of
```
data-statement-object-list / data-statement-value-list /
```
That is, one associates a list of values with a list of variables, e.g.:
```fortran
real a, b, c
data a, b, c / 1.0, 2.0, 3.0 /
```
The `data` statement is quite flexible in syntax, but generally can be
omitted in favour of array constructors or other "more modern" facilities.
The `data` statement cannot be used to initialise allocatable or pointer
variables.


## Heap storage

Storage for arrays may be established at run time via the `allocatable`
attribute, e.g.:
```fortran
   real, allocatable :: a(:)
   ! ...
   allocate(a(1:nlen))
   ! ...
   deallocate(a)
```
The _allocation status_ of the array may be interrogated via the
intrinsic function `allocated()`.

### Assignment as allocation

One may combine allocation with initialisation in a number of ways
including:
```fortran
  real, allocatable :: a(:)
  real, allocatable :: b(:)
  real, allocatable :: c(:)

  a = [ 1.0, 2.0, 3.0 ]          ! status now allocated
  allocate(b, source = a)        ! "sourced allocation"
  c = b(:)
```
Automatic reallocation is also possible for intrinsic assignments, e.g.,
following on from the above:
```fortran
  a = [ a(:), 4.0, 5.0, 6.0 ]    ! Append to the existing elements
```

Allocatable scalars are allowed and may be useful in some circumstances.

## Zero-sized arrays

Formally, a zero-sized allocation is not well defined by `malloc()`
in C. However, as Fortran arrays are objects, zero-sized arrays
are possible:
```fortran
  integer :: a(0)      ! a zero-sized array
  integer :: b(0:0)    ! an array with one element b(0)
```
This can make it easier to write generic code which does not have to
include conditionals to handle edge-cases where the array size might
go to zero.

Two zero-sized arrays of the same rank may have different shapes, and
so do not necessarily conform (although a zero-sized array always
confirms with a scalar, as usual). As a zero-sized array has no
elements, it is always considered to be defined.


## Exercise (3 minutes)

Look at the accompanying programs to be found in the current directory.
```
problem1.f90       ! needs completing
problem2.f90       ! will fail to compile; correct
problem3.f90       ! will fail at run time; what is the problem?
```
These may be compiled with, e.g.,
```
$ ftn problem1.f90
```

## Exercise (2 minutes)

As arrays are self-describing in Fortran, it is relatively easy for the
compiler to analyse whether array accesses are valid, or within bounds.
This can help debugging. Most compilers will have an option that instructs
the compiler to inject additional code which checks bounds at run time.
For the Cray Fortran compiler, this is `-hbounds`; for the GNU compiler,
this is `-fbounds-check`.

The first example contains a fixed array element reference which is
incorrect. This should be visible to the compiler at compile time:
```bash
$ ftn -hbounds bounds-compile-time.f90
```
The second example prompts for an array index at run time. This may
or may not be out of bounds. Check what happens at run time if the
value of `4` is entered.
```bash
$ ftn -hbounds bounds-run-time.f90
```
