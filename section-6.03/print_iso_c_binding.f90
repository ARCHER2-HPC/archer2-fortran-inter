program print_iso_c_binding

  ! The contents of iso_c_binding

  use iso_c_binding
  implicit none

  print "('c_int                 ', i8)", c_int
  print "('c_short               ', i8)", c_short
  print "('c_long                ', i8)", c_long
  print "('c_long_long           ', i8)", c_long_long
  print "('c_sigmed_char         ', i8)", c_signed_char
  print "('c_size_t              ', i8)", c_size_t
  print "('c_int8_t              ', i8)", c_int8_t
  print "('c_int32_t             ', i8)", c_int32_t
  print "('c_int64_t             ', i8)", c_int64_t
  print "('c_int_least8_t        ', i8)", c_int_least8_t
  print "('c_int_least16_t       ', i8)", c_int_least16_t
  print "('c_int_least32_t       ', i8)", c_int_least32_t
  print "('c_int_least64_t       ', i8)", c_int_least64_t
  print "('c_int_fast8_t         ', i8)", c_int_fast8_t
  print "('c_int_fast16_t        ', i8)", c_int_fast16_t
  print "('c_int_fast32_t        ', i8)", c_int_fast32_t
  print "('c_int_fast64_t        ', i8)", c_int_fast64_t
  print "('c_intmax_t            ', i8)", c_intmax_t
  print "('c_intptr_t            ', i8)", c_intptr_t

  print "('c_float               ', i8)", c_float
  print "('c_double              ', i8)", c_double
  print "('c_long_doublw         ', i8)", c_long_double

  print "('c_float_complex       ', i8)", c_float_complex
  print "('c_double_complex      ', i8)", c_double_complex
  print "('c_long_double_complex ', i8)", c_long_double_complex

  print "('c_bool                ', i8)", c_bool
  print "('c_char                ', i8)", c_char

end program print_iso_c_binding
