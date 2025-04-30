# Interfaces and overloading

The `interface` block has three different forms in Fortran: it may define an
_abstract_ interface, a _generic_ interface, or a _specific_ interface.

In this section, we will look at generic interfaces. Generic is the term
which describes overloading in Fortran.


## Generic interfaces

The formal description of an interface block in the generic context is
```
interface generic-spec
  [ interface-specification ] ...
end interface generic-spec
```
The `generic-spec` has a number of different possible forms:
- `assignment (=)` for assignment
- a generic procedure name
- `operator (defined-operator)` for an operator
- a derived type i/o operation

We have seen an example of this type of interface in the  context of
overloading assignment, e.g.,
```
interface assignment (=)
  module procedure :: my_assignment
end interface assignment (=)
```

There are one or more `interface-specification` entries which can take
different forms. As we will usually expect to place interface deinfitions
in a module along the relevant procedure definitions,
the `interface-specification` will often involve one or more
`module procedure` statements of the form
```
  [ module ] procedure [ :: ] specific-procedure-list
```

The `module` in `module procedure` in the interface block is
optional: we could use external procedures. However, it may be most
natural to place the interface in the relevant module. The procedure
interface must be available in either form.

### Generic assignment

We have seen an example of overloading assignment in the previous section:
```
interface assignment (=)
  module procedure :: my_assignment
end interface assignment (=)
```
In this context, the procedure must be a subroutine (not a function) with
exactly two non-optional arguments. To prevent ambiguity, the first argument
must correspond to the left-hand side of the assignment an have
`intent(inout)` or `intent(out)`, while the second argument must represent
the right-hand side of the assignment and have `intent(in)`.

Redefining assignment between intrinsic types is not allowed, including
redefining conforming array assignments. It is possible to define
assignment between an intrinsic type and a derived type. For example,
using the `my_array_t` again from the previous section:
```
subroutine my_assignment_from_int(a, ival)

  type (my_array_t), intent(inout) :: a
  integer,           intent(in)    :: ival

  a%values(:) = ival

end subroutine my_assignment_from_int
```
In this way, one can have a number of different procedures which overload the
assignment: they are generic.

If the right-hand side is an expression, one can consider the assignment as
being replaced by a call to the subroutine, with the second argument being
the expression enclosed in parentheses (the right-hand side).

If an _elemental_ subroutine is provided as a generic interface, both scalar
and array assignments can be performed. Particular combinations
of ranks may be specified (in which case intrinsic assignment remains
available for other combinations).


### Generic procedures

A generic procedure allows one to associate a generic name with one or more
specific procedures.
```
interface generic-name
  module procedure :: specific-prcedure-list
end interface generic-name
```
The `specific-procedure-list` can be a comma-separated list of
different implementations, or one may add new implementation on
different lines. For example,
```
interface my_generic_name
  module procedure :: my_real32_implementation
  module procedure :: my_real64_implementation
end interface my_generic_name
```
We are required to implement subroutines which are
_distinguishable_ by their arguments. A `procedure-list` must consist of
either all subroutines or all functions: there cannot be a mix of
subroutines and functions.

### Distinguishable procedures

In order that the compiler can identify unambiguously the appropriate
specific implementation based on the actual arguments at the point of
invocation, the signatures of a generic procedure must be distinguishable.

Individual pairs of dummy arguments are distinguishable:
- if both are data objects and have different types, kind type parameters
or ranks;
- if one is allocatable and the other is a pointer;
- if one is a procedure and the other is a data object.

Together, the set of non-optional arguments in each case
must be distinguishable. Note that the order may not be counted upon if the
dummy arguments have the same name, as one can always call using keywords
at the point of invocation, e.g.,
```
  call my_subroutine(arg2 = y, arg1 = x)
```

The presence or absence of a pointer attribute in the dummy argument is not
enough to disambiguate a call; a pointer actual argument can be associated
with dummy argument which is a non-pointer data object.

### Example (4 minutes)

Looking again at our `my_array_t` example, check that you can overload the
default structure constructor `my_array_t()` using the existing function
`my_array_allocate()`. A new version of the module and program are available
in the current directory (or you can keep your existing one).
```
$ ftn my_array_type.f90 example1.f90
```
Add a new overloaded version to the same generic name which allows us to
allocate a new array of a given size, but with the values initialised
uniformly by a scalar integer supplied as a second argument to the new
implementation. Check this works as expected.

### Example (2 minutes)

The following is an edge-case which will not compile, as the dummy arguments
of the two subroutines in the generic interface are ambiguous.
```
$ ftn -c example2.f90
```
There's actually a simple solution to the problem. Can you see what it is
(think about the keyword argument case)?


## Overloading operators

It is possible to overload an intrinsic operator (such as `+`), or define a
new name for an operation. The intrinsic operators include arithmetic
operators `+, -, *, /` etc, logical operators including `.not., .or.`,
and relational operators including `==, <, <=`. The choice of name or
symbol may depend on how meaning is ascribed to the operation.

To do so, one must provide a function (not a subroutine) taking exactly
one argument for unary operations such as negation, or exactly two
arguments for binary operations such as multiplication. The arguments
must be `intent(in)` in both cases. The arguments cannot be optional.

One cannot overload operations for intrinsic types. They are only relevant
for combinations of derived types, or derived types and intrinsic types.

For example, if we had two types
```
type (date_time_t)      :: now       ! a date and time
type (time_interval_t)  :: dt        ! interval in seconds
```
one might wish to overload the meaning of `+` to allow an interval to be
added to a date. This could be done as follows, assume we have a module
which makes available both types:
```
interface operator (+)
  module procedure :: add_interval_to_date_time
end interface operator (+)
```
We would then have to supply the function
```
function add_interval_to_date_time(date, dt) result(newdate)

  type (date_time_t),     intent(in) :: date
  type (time_interval_t), intent(in) :: dt
  type (date_time_t).                :: newdate

  ! ... details of implementation ...

end function add_interval_to_date_time
```

An expression of the form
```
now + dt
```
would then be replaced by the result of the function, which in this case
is of type `date_time_t`.

The order is significant here. The left-hand operand of the operation
corresponds to the first dummy argument, and the right-hand operand
corresponds to the second dummy argument. So one could not have
`dt + now`.

One could, equivalently, invoke the function directly:
```
  type (date_time_t) :: newdate
  ...
  newdate = add_interval_to_date(now, dt)
```

#### Caution

This is a (deliberately) somewhat contentious example. It raises a number
of general concerns about the approach:
1. If operations involves single type, the operands are interchangeable,
   and a limited number of functions is required.
2. If operations involving even one defined type, and one intrinsic type
   are required, then  the number of possible operations can quickly
   become quite large (without asking the question whether specific
   operations have meaning).

So it can be quite difficult to achieve a complete, consistent, and
transparent set of operations for any new type.


### Using a non-intrinsic name

We could equally define a new name
```
  interface operator(.add.)
    module procedure add_interval_to_date
  end interface operator (.add.)
```
in which case we would write
```
   newtime = now .add. dt
```
A new name must be of this form (having `.` at start and finish) and must
not be either `.true.` or `.false.`.

If one limits the choice to the intrinsic operator names, the precedence of
the different operations is the same, e.g., the precedence of `*` is always
greater than `+`. If using new names, precedence in complex expressions may
need to be established via parentheses.


### Exercise (10 minutes)

Write a module which defines a type to hold a 3-vector $(u_1, u_2, u_3)$ where
the components are integers. Define an operator `.x.` which
computes the cross product of two vectors, being

$$\mathbf{u}\times \mathbf{v} = (u_2 v_3 - u_3 v_2, u_3 v_1 - u_1 v_3, u_1 v_2 - u_2 v_1).$$

This should also allow a vector triple product $\mathbf{u}\times(\mathbf{v}\times\mathbf{w})$.
where one must use parentheses to obtain the desiredd result.

One could also define a scalar product `.dot.`, being
$$\mathbf{u}.\mathbf{v} = u_1 v_1 + u_2 v_2 + u_3 v_3.$$
Does a scalar triple product $\mathbf{u}.\mathbf{v}\times\mathbf{w}$ work correctly
without parentheses?

A template is provided
```
$ ftn example3.f90 my_vector_type.f90
```
where the example program has a number of suggestions to check the results.
