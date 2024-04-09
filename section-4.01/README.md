# Abstract types

The ability to have abstraction is a very powerful tool in software
engineering.

## Defining an abstract type

An abstract type is defined with the `abstract` attribute, schematically:
```
  type, abstract, public :: my_abstract_t
    ! ... usually has no components ...
  contains
    procedure (interface1), deferred :: binding1
    procedure (interface2), deferred :: binding2
    ! ... and so on ...
  end type my_abstract_t

  abstract interface
    ! ... relevant for interface1 and so on ...
  end interface
```
It is often the case that an abstract type defines only interface,
or supported behaviours,
and not components (a lack of concrete components can be considered
a characteristic of an abstract entity).

The `deferred` attribute in the `procedure` declarations indicates
that the actual implementation is yet to be specified
(cf. virtual in C++). Only abstract tpyes may have `deferred`
attribute for procedures. Interface blocks - typically abstract - must
be provided for each type-bound procedure. This is done in the same
way as for non-abstract types as we have seen before.

An object of an abstract type is not permitted:
```
  type (my_abstract_t) :: a            ! erroneous
```
A polymorphic pointer must be used:
```
  class (my_abstract_t), pointer :: a  ! ok. pointer to abstract type
```

### A concrete implementation

A concrete implementation would extend the abtract type
```
  type, extends(my_abstract_t), public :: my_concrete_t
    private
    ! ... implementation often private ...
  contains
    procedure :: binding1 => my_implementation1
    procedute :: binding2 => my_implementation2
    ! ... and so on ...
  end type my_concrete_t
```
and would have to provide appropriate implementations for the
deferred procedures consistent with the relevant interface.
A concrete type extending an abstract type _must_ implement any
remaining deferred procedures.

A type extending an abstract type may itself be abstract, and
the definitions of its type-bounds procedures can remain
`deferred`, but could also be implemented in the abstract type.


### Constructor

As usual, a concrete type would typically provide some way to
instantiate itself. Schematically,
```
  function my_concrete_type_create(...) result(p)

    ! ... arguments ...
    type (my_concrete_t), pointer :: p

    allocate(p)
     ...
  end function my_concrete_type_create
```
And then, schematically,
```
   class (my_abstract_t), pointer :: a => null()

   a => my_concrete_type_create(...)

   call a%binding1(...)
```
As `a` is type-compatible with extending types, and we are able to write
code in which we do not care about the details of the implementation,
but only access the public (abstract) interface. This excepts the
constructor itself.

## An example


### Exercise

