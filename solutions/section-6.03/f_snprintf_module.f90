module f_snprintf_module

  use, intrinsic :: iso_c_binding
  implicit none
  public

  interface
    integer (c_int) function f_snprintf_float(str, sz, cformat, x) &
         bind(c, name = "c_snprintf_float")
      use iso_c_binding, only : c_int, c_char, c_size_t, c_float
      character (kind = c_char, len = 1),        intent(out) :: str(*)
      integer   (kind = c_size_t),        value, intent(in)  :: sz
      character (kind = c_char, len = 1),        intent(in)  :: cformat(*)
      real      (kind = c_float),         value, intent(in)  :: x
    end function f_snprintf_float

    function f_snprintf_double(str, sz, cformat, x) &
         bind(c, name = "c_snprintf_double") result(nchar)
      use iso_c_binding, only : c_int, c_char, c_size_t, c_double
      character (kind = c_char, len = 1),        intent(out) :: str(*)
      integer   (kind = c_size_t),        value, intent(in)  :: sz
      character (kind = c_char, len = 1),        intent(in)  :: cformat(*)
      real      (kind = c_double),        value, intent(in)  :: x
      integer   (kind = c_int)                               :: nchar
    end function f_snprintf_double
  end interface

end module f_snprintf_module
