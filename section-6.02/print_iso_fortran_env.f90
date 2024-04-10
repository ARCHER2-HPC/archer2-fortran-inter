program print_iso_fortran_env

  use, intrinsic :: iso_fortran_env
  implicit none

  character (len = *), parameter :: compiler = compiler_version()
  character (len = *), parameter :: options  = compiler_options()

  print "('Error unit             ', i8)", error_unit
  print "('Input unit             ', i8)", input_unit
  print "('Output unit            ', i8)", output_unit

  print "('iostat_end             ', i8)", iostat_end
  print "('iostat_eor             ', i8)", iostat_eor

  print "('character storage size ', i8)", character_storage_size
  print "('file storage size      ', i8)", file_storage_size
  print "('numerical storage size ', i8)", numeric_storage_size

  print "('int8                   ', i8)", int8
  print "('int16                  ', i8)", int16
  print "('int32                  ', i8)", int32
  print "('int64                  ', i8)", int64
  print "('size(integer_kinds)    ', i8)", size(integer_kinds)

  print "('real32                 ', i8)", real32
  print "('real64                 ', i8)", real64
  print "('real128                ', i8)", real128
  print "('size(real_kinds)       ', i8)", size(real_kinds)

  print "('size(logical_kinds)    ', i8)", size(logical_kinds)
  print "('size(character_kinds)  ', i8)", size(character_kinds)

  print "('compiler_version():     ', a)", compiler
  print "('compiler_options():     ', a)", options

end program print_iso_fortran_env
