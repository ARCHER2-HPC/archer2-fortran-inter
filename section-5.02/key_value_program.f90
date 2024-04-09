program key_value_program

  ! Generate three key value pairs of different types, then
  ! add then to a list.

  use key_value_module
  implicit none

  type (key_value_t) :: kv1 = key_value_t()
  type (key_value_t) :: kv2 = key_value_t()
  type (key_value_t) :: kv3 = key_value_t()
  type (key_value_t) :: kv4
  type (key_value_t) :: kv5

  type (key_value_list_t) :: alist

  kv1 = key_value_t("kv1", 2)
  kv2 = key_value_t("kv2", 3.141)
  kv3 = key_value_t("kv3", "foo")

  kv4 = key_value_t("kv4", 2.7)
  kv5 = key_value_t("kv5", kv4)

  call key_value_print(kv1)
  call key_value_print(kv2)
  call key_value_print(kv3)
  call key_value_print(kv4)
  call key_value_print(kv5)

  alist = key_value_list_t()

  call key_value_list_add_kv(alist, kv1)
  call key_value_list_add_kv(alist, kv2)
  call key_value_list_add_kv(alist, kv3)

  call key_value_release(kv3)
  call key_value_release(kv2)
  call key_value_release(kv1)

  call key_value_list_print(alist)

end program key_value_program
