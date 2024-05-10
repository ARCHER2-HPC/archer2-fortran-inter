program example1

  use f_snprintf_module
  implicit none

  integer (c_size_t),  parameter       :: sz = 80
  character (kind = c_char, len = sz)  :: str = ""
  character (kind = c_char, len = 10)  :: cformat = "%5.3f"
  real    (c_float)                    :: x = 3.14e0
  real    (c_double)                   :: y = 2.71d0

  integer (c_int) :: nwrite = 0

  print *, "Format ", cformat
  nwrite = f_snprintf_float(str, sz, trim(cformat), x)
  print *, "Return value ", nwrite
  print *, "Index ", index(str, c_null_char)
  print *, "String ", trim(str), len_trim(str), str(1:5)

  cformat = "%22.15e"
  nwrite = f_snprintf_double(str, sz, trim(cformat), y)
  print *, "return value ", nwrite
  print *, "String ", trim(str)

end program example1
