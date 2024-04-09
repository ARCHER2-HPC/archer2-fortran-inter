# Unlimited polymorphic entities

It is sometimes useful in C to be able to use a `void *` pointer,
a pointer for which there is no type-checking at compile time.
The nearest analogue in Fortran in the unlimited polymorphic
pointer.

## `class (*)` pointers

We have seen a polymorphic pointer of given class used in the context
of type extension. A more general type of pointer, an _unlimited
polymorphic_ pointer can be declared as
```
  class (*), pointer :: p => null()
```
This is particularly useful if a polymorphic reference of intrinsic
types (which cannot be extended) is required. For example:
```
  real (real32), target  :: r32
  real (real64), target  :: r64
  real (real32), pointer :: p32 => null()
  real (real64), pointer :: p64 => null()

  class (*), pointer     :: p => null()

  p32 => r32      ! ok
  p64 => r64      ! compile-time error
  p   => r34      ! ok
  p   => r64      ! ok
```
While we cannot associate a pointer of a fixed type (`p64`) with a
target of incompatible type, we can with an unlimited polymorphic
pointer.

However, unlike the type-specific pointer, we cannot use the unlimited
polymorphic pointer in any context, e.g.,:
```
  p64 = 2.0d0      ! normal assignment ok
  p   = 2.0d0      ! compile-time error
```
Pointer assignments are valid
```
  p   => p32
  p   => p64
```
If an unlimited polymorphic pointer is on the right-hand side of an assignment,
then the left-hand side must be a pointer to a non-extensible derived type.
E.g.,
```
  p32  => p
```
is not valid, as this allows an association to an incompatible type.

### Exercise (2 minutes)

The accompanying code `example1.f90` has three invalid assignments
which will not compile, and one additional error. Check the compiler
messages for each.


### Use of type guards

Recall that we can use a `select type` construct with appropriate type
gaurds to provide the compiler with concrete information to deal with
the dynamic type. This is appropriate for unlimited polymorphic pointers,
schematically:
```
  class (*), pointer :: p

  select type (p)
    type is (real32)
      ! ... action for real32 ...
    type is (real64)
      ! ... action for real64 ...
  end select
```

## Typed allocation and sourced allocation

Unlimited polymorphic pointers may be used as actual arguments to procedures.
One relevant intrinsic case is `allocate()`. Typed allocation has a form
similar to a constructor which specifies the type:
```
  allocate(type-spec :: alloc-list)
```
This allows allocations against unlimmited polymorphic pointers, e.g.,
```
  class (*), pointer :: p    => null()
  class (*), pointer :: r(:) => null()

  allocate(character (len = 9) :: p)
  allocate(real (real32)       :: r(7))
```

A useful step in many circumstances is to use sourced allocation:
```
  class (*), pointer :: p => null()

  allocate(p, source = a)
```
which will produce a copy of `a`; `p` will take on the dynamic type of `a`.


## Exercise (20 minutes)

### A key value pair

The accompanying template module `key_value_module.f90` provides a
derived type that is intended to store key value pairs, where the
key is a (deferred length) string, and the value is an unlimited
polymorphic pointer.
```
  type, public :: key_value_t
    character (len = :), allocatable :: key
    class (*), pointer               :: val
  end type key_value_t
```
In principle, this can store values of any type.

Implement three specific constructors to establish key-value pairs for
integer and real intrinsic types (`int32` and `real32` from `iso_fortran_env`),
and for strings. Each should allocate appropriate memory for the key and the
value. These should overload the default structure constructor `key_value_t()`.

Implement a subroutine `key_value_print()` which uses a `select type`
construct to display the current type, key and value of the three
different data types.

To be complete, implement a routine to release the resources associated
with a `key_value_t`. We could use type-bound procedures for these
last two operations, but it's not really necessary in this context.

The accompanying program has some examples to act as a test.


### Assumed type (F2018)

It is possible to use a non-pointer unlimited polymorphic dummy argument
in a procedure, e.g.:
```
  subroutine example(upe)

    class (*), intent(in) :: upe
    ! ...

  end subroutine example
```
This does not have the pointer attribute, but has similar constraints.
Such an entity would allow us to replace the three specific constructors
with one which took on the dynamic type of the actual argument. Try it.
Do you think it's a good idea?

### A dynamic list of key value pairs

It might be useful to have an expandable list of such key value pairs.
A possible implementation is also provided in the `key_value_module.f90`

The list constructor and a procedure to add a `key_value_t` are provided.
There's also a routine to print out the list contents.
What remains to be provided is a subroutine which increases the storage as
required. This should use `move_alloc()`. Have a go at providing this
subroutine.
