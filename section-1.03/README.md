# More on pointers

In C, a (bare) pointer is simply a variable that holds an address.
(C++ has more sophisticated pointer types such as `unique_ptr` etc.).
In this section we look more closely at pointers in Fortran.

## Pointer assignment

We recall that a pointer variable may be undefined, unassociated
(sometimes "disassociated"), or associated:
```fortran
  integer, pointer :: p1              ! undefined
  integer, pointer :: p2 => null()    ! unassociated
  integer, pointer :: p3 => t         ! associated with target t
```
The difference between undefined and unassociated is that a undefined
pointer can not have its association status queried by the intrinsic
function `associated()`.

Pointer assignment is of the form:
```
  pointer => target
```
where the target may be a variable with the target attribute, another
pointer, or a function returning a pointer result. The type, type
parameters and rank of both sides of the assignment must match.

### Target is an array

For example, if the target is an array, we might have:
```fortran
  integer, target  :: a(10)
  integer, pointer :: p(:)

  p => a(1:10:2)
```
then the shape and bounds are those the right-hand side. We can see here
that the pointer is not a simple object. It should be viewed as a
descriptor which holds information about what it is pointing to
(in this case a rank 1 array 1:5). Here one could use intrinsic functions
`shape()`, `lbound()`, and `ubound()` to interrogate
the pointer as one would for an array. The pointer must be associated to
do so.

It is possible to specify the lower bound of a pointer array:
```fortran
  p(2:) = a(2:6)
```
in which case elements are indexed from the lower bound when using the
pointer.

A multi-dimensional pointer may be "reshaped" to a lower-dimensional
target. For example:
```fortran
  integer, parameter :: n = 3
  integer, target    :: storage(n*n)
  integer, pointer   :: matrix(:, :)

  matrix(1:n, 1:n) => storage(:)
```
Note that both the lower and upper bounds of `matrix(1:n, 1:n)` are
included on the left-hand side of the pointer assignment.

### Target is a pointer

If the target of an assignment is a pointer, then subsequent changes
in status of the target are not reflected in the later assignment, e.g.,
```fortran
  b => a
  c => b
  nullify(b)
```
leaves `c` associated with `a`.

The `nullify()` statement has the same effect as assignment to `null()`.
However, `nullify()` can take a comma-separated list of pointer arguments
if desired. If the argument has been allocated via `allocate()`, then
`nullify()` will not perform deallocation: use `deallocate()`.


### Exercise: (4 minutes)

Write a program which initialises an integer array `a(10)`
and assigns the elements the values 1-10. Associate a pointer with the
even-numbered elements of `a(2:10)` (as above). Print out the values
returned by the functions `lbound()`, `ubound()` and `size()` when applied
to the pointer. Check the value associated with the fourth element of the
pointer is eight.

A bare outline is provided in `example1.f90`.

## Pointers as arguments

A dummy argument may have the pointer attribute.
If the intent of the dummy argument is `intent(inout)` or `intent(out)`, the
relevant actual argument must also be a pointer.

A pointer actual argument can correspond to a non-pointer dummy argument,
in which case the pointer actual argument must be associated with a
suitable target.


### Arguments must be distinct

C programming has the idea of `restrict` for pointer arguments to functions.
The `restrict` qualifier is a guarantee to the compiler that there
will be no overlap in the memory accessed via different pointers: all the
relevant memory locations are distinct. (If this is not the case then the
situation is often referred to as _aliasing_.) This information can be important,
e.g., to allow the compiler to include, omit, or re-order operations to
perform optimisations.

There is a similar consideration in Fortran, where the mechanism can be
copy-in, copy-out. There are some moderately complex rules on what is
and what is not allowed to ensure that dummy arguments are independent,
both from each other and from entities available via host association,
or any other mechanism.

Broadly: any operation that affects the value of an argument must
be taken via the associated dummy argument alone. This includes
allocation status, and association status for pointers.

1. Consider a case where we have a subroutine of the form
   ```fortran
   subroutine my_array_update(ia, ib)
     integer, intent(inout) :: ia(:)
     integer, intent(inout) :: ib(:)

     ia(:) = ia(:) + 1
     ib(:) = ib(:) / 2
   end subroutine my_array_update
   ```
   If we were to make a `call my_array_update(a(1:10), a(6:15))` we have
   a situation where both dummy arguments are referring to the same
   section of the single actual argument.

   Procedures which have only one `intent(inout)` argument
   can reduce the scope for this potential problem.
2. Consider a case where we have a module procedure, schematically:
   ```fortran
   module my_module
     ! ...
     integer, allocatable, public :: ihost(:)
     ! ...
   contains
     subroutine my_subroutine(iarg)
       integer, allocatable, intent(inout) :: iarg(:)

       ! ... change to the status of iarg(:) or ihost(:) ...
     end subroutine my_subroutine
   end module my_module
   ```
   We now have a situation where ihost(:) may appear as the actual
   argument to `my_subroutine()`. This is best avoided by avoiding
   module scope data.

These restrictions are not enforced by the compiler (it may not even
be possible): violations by the programmer may just be manifest as
undefined behaviour.

### Actual and dummy arguments with target attribute

Likewise, there is a set of conditions on the use of `target` attribute
in the context of procedure arguments. These may be summarised:

1. Pointers associated with an actual argument may not become associated
   with relevant dummy arguments (copy-in, copy-out may occur);
2. If a dummy argument has the `target` attribute, any pointer associated
   with the dummy argument may not be associated on return.


## Procedure declarations

There is a `procedure` statement which declares a name to be a procedure.
In its simplest form, it is equivalent to an external declaration:
```fortran
  procedure () :: f_external
  external     :: f_external
```
Here, the `()` indicates there is no interface information available.
For functions, one may include information on a return type
```fortran
  procedure (integer) :: f_external
  integer, external   :: f_external
```
These are again There is a `procedure` statement which declares a name to be a
procedure. In its simplest form, it is equivalent to an external declaration:
```fortran
  procedure () :: f_external
  external     :: f_external
```
Here, the `()` indicates there is no interface information available.
For functions, one may include information on a return type
```fortran
  procedure (integer) :: f_external
  integer, external   :: f_external
```
These are again equivalent..

The general form is
```
procedure [(interface-spec)] [, attribute-list ::] declaration-list
```
The parentheses accommodate an interface specification, which may be
an interface name, or a declaration type specification (such as
`integer` above). There are a number of
possible attributes, including `pointer`, which declares a pointer to a
procedure.

## Pointers to functions or subroutines: procedure pointers

A procedure having an explicit interface may be the target of a procedure
pointer. The declaration might be as follows:
```fortran
  interface
    function my_external_function(x) result(y)
      real, intent(in) :: x
      real             :: y
    end function my_external_function
  end interface

  procedure (my_external_function), pointer :: f => my_external_function
  ! ...
  y = f(x)
```
Note the name appearing in the interface needs to match that of the
external function. This is sometimes referred to as a _specific_ interface.

We may also define an abstract procedure, which may only appear in the
`interface-name` specification of a procedure declaration.
```fortran
  abstract interface
    function if_function(x) result(y)
      real, intent(in) :: x
      real             :: y
    end function if_function
  end interface
```
An associated procedure definition might be
```fortran
  procedure (if_function) :: my_external_function
```
This is an alternative to the specific interface declaration above.

A procedure pointer must be associated in order to reference the procedure.


### Exercise (10 minutes)

An example of an external function is provided in `external.f90`. This is a
function which has a single argument which is a integer rank 1 array, and
returns an integer which is the size of the array.

The accompanying program `example2.f90` makes a simple `procedure` declaration
to allow the external function to be referenced (similar to an `external`
declaration).
```bash
$ ftn external.f90 example2.f90
```
There a number of possible problems with this example (e.g., what happens
if you provide an actual argument which is a rank two array?).

Adjust the example to provide a _specific_ interface block which describes
the external function. Make an appropriate procedure declaration, and also
try declaring a pointer to the procedure.

Check this works and the the compiler now traps errors associated with
incompatible actual arguments.

Try replacing the specific interface block with an equivalent abstract
interface. Again, call the external function via a name declared in a
procedure statement, and also try a procedure pointer.
