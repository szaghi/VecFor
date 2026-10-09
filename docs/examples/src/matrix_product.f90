!run matrix_product matrix_product
program matrix_product
!< Cookbook: any 3 x 3 matrix applied to a vector.
use penf, only : R8P
use vecfor, only : ex, ey, ez, vector
implicit none
type(vector) :: v, w
real(R8P)    :: shear(3,3)

shear = reshape([1._R8P, 0._R8P, 0._R8P, &      ! by columns: x gains half of y
                 0.5_R8P, 1._R8P, 0._R8P, &
                 0._R8P, 0._R8P, 1._R8P], [3, 3])
v = ex + 2 * ey + 3 * ez
w = shear .matrix. v
call w%printf(prefix='shear .matrix. v = ')
endprogram matrix_product
