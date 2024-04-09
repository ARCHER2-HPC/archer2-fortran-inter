# Generic input/output for derived types

## Default input/output

List-directed output for derived types can be used to provide a default
output in which each component appears in order, schematically:
```
  type (my_type) :: a
  ! ...
  write (*, fmt = *) a
```
will write out all the compoments with some default format for the given
components.

Alternatively, if we know the components, we could write out each component
separately with an appropriate format
```
  write (*, fmt = "(i4)")   a%int1
  write (*, fmt = "(f5.3)") a%real1
```
Fortunately, a mechanism using type-bound procedures is available.

## Non-default input/output

A facility for the user to specify the behaviour of input/output via
an edit descriptor is provided by means of a type-bound procedure.

For formatted i/o, a special `dt` edit-descriptor exists, of the form:
```
  dt[iodesc-string][(v-list)]
```
where the `iodesc-string" is a string, and the v-list is a series of
integers. For example, we may have
```
  dt" my-type: "(2,14)
```
The `iodesc-string` string and `v-list` array of integers will re-appear
as arguments to a type-bound procedure which must be provided by the
programmer.

The following generic procedures may be defined for read or write actions:
```
   read (formatted)
   read (unformatted)
   write (formatted)
   write (unformatted)
```
These provide a mechanism to define a procedure with the relevant interface
1. a `formatted` interface for formatted i/o;
2. an `unformatted` interface to specify unformatted i/o.

The relevant procedure would then be called if a item of that type appeared
in the io list for a `read()` or a `write()` statement.

## Interfaces

### Unformatted output

If we consider the type `my_type`, the unformatted output implementation
requires
```
   subroutine my_type_unformatted_output(self, unit, iostat, iomsg)

     class (my_type),     intent(in)    :: self    ! object
     integer,             intent(in)    :: unit    ! Fortran unit number
     integer,             intent(out)   :: iostat  ! error condition
     character (len = *), intent(inout) :: iomsg   ! error message

     ! ... implementation ...

  end subroutine my_type_unformatted_output
```
The `iostat` and `iomsg` variables take on their usualy meaning in the context
of `write()`.
The `iostat` variable is zero on success, but should take a positive value if
an error occurs. If `iostat` is non-zero, `iomsg`
should contain a short message for the user on the reason for the error.

For input the only difference is that the passed object dummy argument should
be of `intent(inout)`.

### Formatted output

The formatted case includes the addition `iodesc-string` and `v-list`
arguemnts:
```
 subroutine my_type_write_formatted(self, unit, iotype, vlist, iostat, iomsg)

    class (my_type),     intent(in)    :: self
    integer,             intent(in)    :: unit
    character (len = *), intent(in)    :: iotype       ! "DT my-type: "
    integer,             intent(in)    :: vlist(:)     ! (2,14)
    integer,             intent(out)   :: iostat
    character (len = *), intent(inout) :: iomsg

    ! ... process arguments to give required output to unit number ...
    ! iotype is "LISTDIRECTED" for list directed io
    ! iotype is "DTdesc-string" for dt edit descriptor
    ! ...
    ! ... write (unit = unit, fmt = ...)  components ...

    ! iostat and iomsg should be set if there is an error

end subroutine my_type_write_formatted
```
Both parts of the `dt` edit descriptor are optional in the format
specification. If the `iodesc-string` is missed, the corresponding
dummy argument `iotype` is of length zero; if the `v-list` is
omitted, then `vlist` has size zero.

Again, the only difference for input is the intent of the passed
object dummy argument, which must be `intent(inout)`.

## Type-bound procedures

The two procedures above should be declared as generic type-bound procedures
```
type, public :: my_type
  ! ... components ...
contains
  procedure :: my_type_write_formatted
  procedure :: my_type_write_unformatted
  generic   :: write(formatted) => my_type_write_formatted
  generic   :: write(unformatted) => my_type_write_unformatted
end type my_type
```
Some care may be required to write a robust set of procedures handling
the different formatted and unformatted cases.

No additional file operations involving the specified unit number are
allowed in the type-bound procedures. Procedures for reading must only
invoke `read()` and procedures for writing only invoke `write()`.

## Exercise (20 minutes)

Try implementing the generic `write(formatted)` procedure for the following
type:
```
  type, public :: my_date
    integer :: day = 1        ! day 1-31
    integer :: month = 1      ! month 1-12
    integer :: year = 1900    ! year
  end type my_date
```
First, try list directed I/O: the format we would like is `dd/mm/yyyy` for
`01/12/1999` for 1st December 1999.

Then try adding the `dt` edit descriptor to allow some more flexibility. For
example, a `vlist` of 3 integers might control the width of the fields for
each part of the date. This requires constructing an appropriate format string.

