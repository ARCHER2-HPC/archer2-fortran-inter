program key_value_program

  ! Generate three key value pairs of different types.
  ! If the list is implemented they could be added to
  ! a list.

  use key_value_module
  implicit none

  type (key_value_t) :: kv1 = key_value_t()
  type (key_value_t) :: kv2 = key_value_t()
  type (key_value_t) :: kv3 = key_value_t()


  kv1 = key_value_t("kv1", 2)
  kv2 = key_value_t("kv2", 3.141)
  kv3 = key_value_t("kv3", "foo")

  call key_value_print(kv1)
  call key_value_print(kv2)
  call key_value_print(kv3)

end program key_value_program
