# Type-bound procedures

Many languages use the term "methods" to refer to functions or
operations that are associated with particular objects.

Methods are referred to as type-bound procedures in Fortran. They
provide a mechanism to perform operations which are appropriate
for a given (dynamic) type.

## Type-bound procedures

A type-bound procedure is a fixed entity associated with the declaration
of the type, and appears after the `contains` statement in the definition.
For example, consider again the simple `object_t`. Say we wished to add
a function to compute the volume of an object:
```fortran
  type, public ::object_t
    ! ... components ...
  contains
    ! ... procedure bindings ...
    procedure, pass :: volume => object_volume
  end type object_t
```
The `pass` attribute specified in the procedure binding
indicates that the object to which the procedure is bound will be
passed as the first argument of the call of the type-bound
procedure. This argument is called the _passed object dummy
argument_.

Note there is no `pointer` attribute: this is a type-bound procedure.

We must provide a function
```fortran
  function object_volume(self) result(volume)

    class (object_t), intent(in) :: self
    real                         :: volume

    ! ...

  end function object_volume
```
Where we might expect to see a `type` declaration for
the dummy argument (`self`), this has been replaced by `class`.
This is to allow that the call may be made in a context in
which the type has been extended, i.e., `class` permits polymorphism.

To invoke the new type-bound procedure, e.g.:
```fortran
  type (object_t) :: a = object_t()

  print *, "Volume is ", a%volume()
```
Here, the declaration of `a` remains `type` rather than `class`.
There is no polymorphism involved at this point. The object `a`
in this context is associated with the passed object dummy
argument (`self`).

### Exercise (5 minutes)

Using the template `object_type.f90` add the type-bound procedure `volume()`
in the `object_t` type (only). Provide an implementation which sets the
volume to zero. Using the accompanying program `example1.f90` check you
can call new `volume()` procedure for an `object_t`.
```bash
$ ftn object_type.f90 example1.f90
```
Can you also use the same type-bound procedure for the sub-type
`sphere_t`?

## Overriding a specific procedure

Types which extend a base type will inherit type-bound procedures from their
parent. If we wish to relate a different volume computation with a given
object type, we may _override_ the `object_volume()` implementation with a
new implementation.

This can be done by merely re-declaring the procedure binding in the extending
type with the same name, e.g.,:
```fortran
  type, extends(object_t), public :: sphere_t
    ! ...
  contains
    procedure, pass, non_overridable :: volume => sphere_volume
  end type sphere_t
```
Here, the `non_overridable` attribute to the binding specifies that the same
name cannot be further overridden by types which extend `sphere_t`.

An overriding procedure must have exactly the same interface as the relevant
procedure in the parent type, bar the type of the object reference itself.

### Exercise (3 minutes)

Check you can add this specific function in the `sphere_t` type. Re-run the
`example1.f90` to check that objects of different type obtain an appropriate
result.

What happens if you try to override the `volume()` procedure in the
`charged_sphere_t` having declared it `non_overridable`?

## Binding attributes

The form of the type-bound procedure definition in this context is:
```
  procedure [, binding-attr-list] :: type-bound-name [ => specific-name ]
```
where there is a comma-separated list of attributes which may include
1. One of `public` or `private` indicating scope;
2. `non_overridable` indicating this `type-bound-name` may not be
   re-defined in types which extend the current type;
3. `pass` or `nopass`.

The default is that type-bound-procedure receives the _passed object dummy
argument_ as the first dummy argument. There is an optional argument
```
  pass [ (arg) ]
```
which can be used to specify which dummy argument is associated with the
invoking object (required if it's not the first dummy argument).

## Generic type-bound procedures

If one wishes to overload type-bound procedures, an additional step is
required:
```fortran
  type, public :: my_type
    ! ...
  contains
    procedure, pass :: add_real32
    procedure, pass :: add_real64
    generic, public :: add => add_real32, add_real64
  end type my_type
```
Here, the single generic name `add` is intended to be used, and must
be associated with distinguishable alternatives.
As before, this may be used for assignment, operators, generic names, or
derived type i/o.

## Procedure pointer as type component

It is possible to declare a type which has a procedure pointer as a
_component_:
```fortran
  type, public :: my_pp_t
    procedure (interface_pp), pointer :: p
  end type my_pp_t
```
Such a procedure pointer is part of the data associated with an instance
of a type. Different instances of the object may contain pointers to
different procedures as the value is determined at run time. Note that
an interface definition may be required in this context.

## Exercise (5 minutes)

Add an extra type-bound procedure to the `sphere_t` to compute the sphere's
mass using the density and the type-bound `volume()` function. Check this
produces a reasonable result.
