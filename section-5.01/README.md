# Modules again

## Modules

The introductory course encouraged the use of modules to provide structure,
and to separate public interface from private implementation.
Schematically, we have seen:
```fortran
module schematic

  ! Broadly, public "interface"

contains

  ! Broadly, private "implementation"

end module schematic
```
However, ...

We also have a situation in which the (public) interface can remain unchanged,
while a change to the (private) implementation requires recompilation of the
module. This may have knock-on effects requiring re-compilation of any
dependencies. Is this really necessary if we have not changed the interface?

The answer should be no. However, a typical makefile dependency might
cause re-compilation of all units `use`-ing the module `schematic`.
Some (rather baroque) mechanisms have been used to avoid this, e.g.,
making a copy of the `.mod` file, and interrogating whether this changes
on compilation.

The separation of large modules into parts may be desirable, but can
necessitate the proliferation of public entities which might not
really be wanted. Cross-dependencies can also be a problem (the
situation where module `a` wants to use module `b` and vice-versa).

The is not quite satisfactory. A clearer separation between interface
and implementation (cf. C header files) is required.

## Submodules

Submodules may be organised in a tree-like hierarchy, with the ancestor
module as the root.

```fortran
module example

end module example
```
The module should define only the interface (there should probably be
no `contains` statement).

The implementation can then be placed in a submodule:
```fortran
submodule (example) example_a

contains

end submodule example_a
```
Note: 1. the submodule automatically has access to the declarations in
the `example` module via host association. There is no need to `use`
the ancestor module.

Formally, we have:
```
submodule (parent-identifier) submodule-name
  [ specification part ]
  [ module-subprogram-part]
end [submodule [ submodule-name] ]
```
where the `parent-identifier` the XXX

### Submodule procedures

Suppose in our module we define a new data type:
```fortran
  type, public :: example_t
    ...
  end type example_t
```
We can define an interface block using this type (also in the module)
to specify the contract:
```fortran
   interface
     module function example_t() result(e)
       type (example_t) :: e
     end function example_t
   end interface
```
Note the `module` at the start of the `function` declaration, and that
there is no `import` statement required in the interface block.

This would then be implemented in the `submodule` subprogram part:
```fortran
  module function example_t() result(e)
    type (example_t) :: e
    ...
  end function example_t
```
The interface and the function declaration must match precisely (only
the name of the result variable is not formally part of the interface
and need not match).

### Exercise (2 minutes)

Compile (do not link) the `module` and submodule files `example.f90` and
`example_a.f90` in the current directory. E.g.,
```bash
$ ftn -c example.f90 example_a.f90
```
Check what additional files have been generated (the exact details
will depend on the compiler: some produce `.smod` files, others
just additional `.mod` files).


### Abbreviated form

It's possible to omit the interface details in the submodule. E.g.,
```fortran
  module procedure example_t
    ...
  end procedure example_t
```
Note the use of `procedure` here. Again, the details must match the
interface declared in the module.

While this provides some saving in verbosity, it may be preferable to
keep the full form.


### Host association and use association


### Submodule declarations

Note that submodules do not contain `public` or `private` declarations.
However, additional variables, types, or named constants may be defined
in a submodule specification part. These a neither public nor private,
but can only be accessed in the submodule and any descendants by host
association.

## Comment

Submodules may only really come into their own if you have an extremely
large software project for which the overheads of re-compilation are
high, or the organisation of extremely large single modules becomes a
problem. For small exercises, such as those presented in this course, the
additional files involved are probably an unnecessary distraction. So
we will only use them on one occasion.

## Exercise (15 minutes)

We will take the single module developed for the `file_writer_t` and split
it into a module containing the abstract definition, and one or two
implementations. A client program should then only depend on the top-level
(abstract) interface.

It's probably easiest to make a number of copies of a working solution
module, and then delete unwanted parts from each. Suggested procedure:

1. Keep the abstract type `file_writer_t` definition and its related
   interface block in `file_module.f90`. Here we will also need an
   interface for the `file_writer_from_string()` function. Check the
   new `file_module.f90` compiles on its own.
3. Make a new (ordinary) module `file_unformatted` for the unformatted
   implementation in a separate file,
   and a new module `file_formatted` for the formatted implementation.
5. Add a submodule to `file_module` to hold the implementation of the
   `file_writer_from_string()` function in s separate file.

An example program which only has `use file_module` will now depend only
on the public definition of the abstract type.

All the Fortran sources should be compiled together to produce an
executable.

What further decomposition into submodules could we make at this point?


