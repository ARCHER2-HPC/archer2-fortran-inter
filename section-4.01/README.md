# Abstract types

The ability to have abstraction in our programs is really the feature that
allows one to write flexible and extensible software.

## Defining an abstract type

An abstract type is defined with the `abstract` attribute, schematically:
```
  type, abstract, public :: my_abstract_t
    ! ... usually has no components ...
  contains
    procedure (interface1), pass, deferred :: binding1
    procedure (interface2), pass, deferred :: binding2
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
(cf. virtual in C++). Only abstract types may have `deferred`
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

A concrete implementation would extend the abstract type
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

## An object type again

Suppose we wished to refactor our `object_t` from the previous section to be an abstract
type. We wish to provide a type-bound procedure to compute the colume of different
objects.
```
   type, abstract, public :: object_t
     ! ... no components here
   contains
     procedure (if_volume), pass, deferred :: volume
   end type object_t
```
We need to specify an interface for the volume procedure, which will use the passed object
dummy argument, and return a scalar real number:
```
  abstract interface
    function if_volume(self) result(volume)
      import object_t
      class (object_t), intent(in) :: self
      real                         :: volume
    end function if_volume
  end interface
```
Here, the function is declared with a anme matching the interface name in the type
definition. The procedure will ultimately be called using the bound name `volume()`.

As the interface block does not have access to the definitions from the outside
scope, we have used the `import` statement to make the name `object_t` available
to allow us to declare the dummy variable.

### Exercise (15 minutes)

Suppose we have some data which we would like to be able to store in files of
different formats. Such formats might be native Fortran formats, or might use
libraries such as NetCDF or HDF5. For simplicity, we will restrict ourselves
to Fortran output.

We could think of representing the act of storing data to a file with three
separate stages:
1. open the file with an appropriate file name;
2. write the data to the file;
3. close the file when complete.

This is an opportunity for an abstract type. We do not wish to specify the
details of the data format at this point, just the three oparations involved.

Write a new module which contains an abstract class with three deferred
procedures. The abstract type might be called `file_writer_t`. The three
procedures can be functions or subroutines. If functions, the interface
we want is:
1. `function f_open(self, filename) result(ierr)` where filename is a string
   and the return value is an integer error code;
2. `function f_write(self, data) result(ierr)` where the data should be, for
   simplicity, a rank 1 array of integers;
3. `function f_close(self) result(ierr)` which closes the file.

(Subroutines would be similar, but with an `intent(out)` integer error code.)

In all cases the passed object dummy argument should be `intent(inout)` to
allow that the internal state assovciated with the file write can be updated.
The `data` argument for the `f_write()` function can be `intent(in)`.

At this point you can check only that the module compiles successfully:
```
$ ftn -c file_writer_module.f90
```

Hint: it may be useful to open the file with `status = "replace"` to prevent
the need to delete files each time before running the program we are working
towards.

## A concrete implementation

A concrete implementation of the abstract `object_t` might look like:
```
   type, extends(object_t), public :: sphere_t
     real, private :: a   ! radius
   contains
     procedure, pass :: volume => sphere_volume
   end type sphere_t
```
Notice the type is no longer `abstract`, and the procedure definition is no longer
deferred. In addition, onlt deferred definitions require an interface specification.

The function `sphere_volume()` would be:
```
   function sphere_volume(self) result(volume)
     class (sphere_t), intent(in) :: self
     real                         :: volume

     volume = ...

   end function sphere_volume
```
This implementation must follow exactly the specification in the interface block,
including the names of the dummy arguments.


### Exercise (15 minutes)

When your abstract definition of the `file_writer_t` is compiling successfully,
add a concrete implementation which just uses Fortran formatted i/o to write
the data to a file. What is the minimum state we must keep in the component
part to remember the file between `open()`, `write()`, and `close()` operations.

Write a short program to check you can use an object of the new type to write
some test data to a file.


## Two implementations

Let us say we now have two implementations of the `object_t` abstract type
which are "sphere_t" and "cube_t".

It would be attractive to be able to choose between the two in a simple
way without worrying about the details of the specific implementations.
Here we can use a polymorphic pointer to the abstract type.

Schematically
```
   class (object_t), pointer :: obj => null()

   obj => object_from_string("cube")
   ...
   print *, "Volume is ", obj%volume()
```
where the `object_from_string()` function returns an appropriate pointer
to the object requested.

A function to return a pointer to one particular type might be
```
  function cube_create() result(p)

    class (cube_t), pointer :: p
    allocate(p)

  end function cube_create
```
Two such functions could be combined to return the polymorphic result of the
abstract type `file_writer_t`. Memory has been allocated against p to
instantiate the object.

### Exercise (15 minutes)

Add a function in `file_module.f90` to return a pointer based on a string. This
should allow at least one working `file_write_t` implementation.

Adjust your main program to be completely abstract.
