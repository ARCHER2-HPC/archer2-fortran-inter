module example_module

  implicit none
  public

  type, public :: example_t
    private
    integer :: data = 0
  end type example_t

  interface example_t
    module function example_int_t(ival) result(e)
      integer, intent(in) :: ival 
      type (example_t)    :: e
    end function example_int_t
  end interface example_t
  
end module example_module
