program probe
!< Tutorial, chapter 1: the four vertices of a tetrahedron, and a point.
use penf, only : R8P
use vecfor, only : ex, ey, ez, vector
implicit none
type(vector) :: o    ! the origin
type(vector) :: p(4) ! the vertices
type(vector) :: q    ! a point, set component by component

p(1) = o                  ! a new vector is (0, 0, 0)
p(2) = ex                 ! the Cartesian versors: unit vectors along x, y and z
p(3) = ey
p(4) = ez
q%x = 0.8_R8P             ! the components are real(R8P)
q%y = 0.6_R8P
q%z = 0.8_R8P
call p(1)%printf(prefix='p1 = ')
call p(2)%printf(prefix='p2 = ')
call p(3)%printf(prefix='p3 = ')
call p(4)%printf(prefix='p4 = ')
call q%printf(prefix='q  = ')
print '(A,F4.2)', 'the x of q is ', q%x
endprogram probe
