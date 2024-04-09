program example1

  use file_module
  implicit none

  class (file_writer_t), pointer :: f => null()
  integer :: data(4) = [ 2, 4, 6, 8 ]
  integer :: ierr

  f => file_writer_from_string("formatted")

  ierr = f%open("data_formatted.dat")
  ierr = f%write(data)
  ierr = f%close()

  deallocate(f)

  f => file_writer_from_string("unformatted")

  ierr = f%open("data_unformatted.dat")
  ierr = f%write(data)
  ierr = f%close()

  deallocate(f)

end program example1
