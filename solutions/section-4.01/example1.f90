program example1

  ! Write a file using the concrete class for formatted output.
  ! Compile with: ftn file_module.f90 example1.f90

  use file_module
  implicit none

  type (file_formatted_writer_t) :: f
  integer :: data(4) = [ 3.0, 5.0, 7.0, 9.0 ]
  integer :: ierr

  ierr = f%open("file_formatted.dat")
  ierr = f%write(data)
  ierr = f%close()

end program example1
