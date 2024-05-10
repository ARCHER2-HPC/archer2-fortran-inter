module key_value_module

  ! Two types are defined:

  ! key_value_t to hold key value pairs, where the key is a string,
  !             and the value is an unlimited polymporphic type
  !
  ! The following interface is wanted:
  !
  ! A generic function to return a new key_value_t for
  !    kv = key_value_t(key, int32)     key-value pair for int32 value
  !    kv = key_value_t(key, real32)    ditto for real32 value
  !    kv = key_value_t(key, string)    ditto for string value
  !
  ! subroutine key_value_release(kv)    to release/destroy resources
  ! subroutine key_value_print(kv)      utility to print key/value pair

  ! key_value_list_t an exapndable list of key_value_t pairs

  use iso_fortran_env

  implicit none
  public

  type, public :: key_value_t
    character (len = :), allocatable :: key             ! The key ...
    class (*), pointer               :: val => null()   ! ... value
  end type key_value_t

  type, public :: key_value_list_t
    integer                         :: npair = 0 ! Current number of pairs
    type (key_value_t), allocatable :: kv(:)     ! Expandable list
  end type key_value_list_t

  ! We will make the specific versions private; one must use the generic
  ! name.
  private :: key_value_create_i32
  private :: key_value_create_r32
  private :: key_value_create_str

contains

  !---------------------------------------------------------------------------
  !---------------------------------------------------------------------------

  function key_value_create_str(key, str) result(kv)

    ! Return aggregated key / value pair - note with trim(str)

    character (len = *), intent(in) :: key
    character (len = *), intent(in) :: str
    type (key_value_t)              :: kv

    kv%key = trim(key)
    allocate(kv%val, source = trim(str))

  end function key_value_create_str

  !---------------------------------------------------------------------------
  !---------------------------------------------------------------------------

  !----------------------------------------------------------------------------
  !----------------------------------------------------------------------------

  function key_value_list_empty_t() result(kvlist)

    ! Return a newly created empty list; allocate size zero pairs.

    type (key_value_list_t) :: kvlist

    kvlist%npair = 0
    allocate(kvlist%kv(0))

  end function key_value_list_empty_t

  !---------------------------------------------------------------------------
  !---------------------------------------------------------------------------

  subroutine key_value_list_release(kvlist)

    ! Release list storage (assume allocated).

    type (key_value_list_t), intent(inout) :: kvlist

    integer :: ikv

    do ikv = 1, kvlist%npair
      call key_value_release(kvlist%kv(ikv))
    end do

    deallocate(kvlist%kv)
    kvlist%npair = 0

  end subroutine key_value_list_release

  !---------------------------------------------------------------------------
  !---------------------------------------------------------------------------

  subroutine key_value_list_add_kv(kvlist, kv)

    ! Add attribute to list

    type (key_value_list_t), intent(inout) :: kvlist
    type (key_value_t),      intent(in)    :: kv

    integer :: nnew

    nnew = kvlist%npair + 1
    if (nnew > size(kvlist%kv)) call key_value_list_reallocate(kvlist)

    kvlist%npair = nnew
    kvlist%kv(nnew)%key = kv%key
    allocate(kvlist%kv(nnew)%val, source = kv%val)

  end subroutine key_value_list_add_kv

  !---------------------------------------------------------------------------
  !---------------------------------------------------------------------------

  subroutine key_value_list_print(kvlist)

    ! List items

    type (key_value_list_t), intent(in) :: kvlist

    integer :: ib

    print *, "List has (size, current pairs): ", size(kvlist%kv), kvlist%npair
    do ib = 1, kvlist%npair
      call key_value_print(kvlist%kv(ib))
    end do

  end subroutine key_value_list_print

  !---------------------------------------------------------------------------
  !---------------------------------------------------------------------------

  subroutine key_value_list_reallocate(kvlist)

    ! Expand list storage (by a factor of 2)

    type (key_value_list_t), intent(inout) :: kvlist

    ! .. implementation required

  end subroutine key_value_list_reallocate

end module key_value_module
