submodule (example_module) example_submodule

  implicit none

contains

  function example_int_t(ival) result(e)

    integer, intent(in) :: ival
    type (example_t)    :: e

    e%data = ival

  end function example_int_t

end submodule example_submodule
