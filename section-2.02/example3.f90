program example3

  use my_vector_type
  implicit none

  type (my_vector_t) :: i = my_vector_t(1, 0, 0)
  type (my_vector_t) :: j = my_vector_t(0, 1, 0)
  type (my_vector_t) :: k = my_vector_t(0, 0, 1)

  ! scalar products
  ! i .dot. i should be 1
  ! i .dot. j should be 0

  ! vector products
  ! i .x. j should be k
  ! j .x. k should be i
  ! k .x. j should be -i

  ! scalar triple product
  ! i .dot. j .x. k should be 1

  ! vector triple product
  ! j .x. (i .x. j) should be (1, 0, 0)

end program example3
