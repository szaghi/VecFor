!as probe
!run probe_9q probe
!quad
program probe
!< Tutorial, chapter 9: the same edge in single, double and quadruple precision.
use, intrinsic :: iso_fortran_env, only : real128
use penf, only : R4P, R8P, R16P
use vecfor, only : ex_R4P, ey_R4P, ex_R8P, ey_R8P, ex_R16P, ey_R16P, normL2_R4P, vector, vector_R4P, vector_R8P, &
                   vector_R16P
implicit none
type(vector_R4P)  :: a4  ! single precision
type(vector_R8P)  :: a8  ! double precision
type(vector_R16P) :: a16 ! quadruple precision, if the library is built for it
type(vector)      :: a   ! the default: double precision
real(real128)     :: l   ! the exact length, sqrt(2), to 33 digits

l = sqrt(2._real128)
!region kinds
a4  = ey_R4P  - ex_R4P                       ! each kind has its own versors
a8  = ey_R8P  - ex_R8P
a16 = ey_R16P - ex_R16P
print '(A,I3,A,ES10.2)', 'R4P : digits', precision(a4%x),  ', error of the length', &
                         abs(a4%normL2()  - l)
print '(A,I3,A,ES10.2)', 'R8P : digits', precision(a8%x),  ', error of the length', &
                         abs(a8%normL2()  - l)
print '(A,I3,A,ES10.2)', 'R16P: digits', precision(a16%x), ', error of the length', &
                         abs(a16%normL2() - l)
print '(A,I3)',          'vector: digits', precision(a%x)
!endregion kinds
!region scalars
a4 = a4 * 0.1_R8P                            ! a scalar of another kind is converted to the kind of the vector
print '(A,ES16.8)', 'x of a4 * 0.1    ', a4%x
print '(A,ES16.8)', 'length, function ', normL2_R4P(a4)
!endregion scalars
!region convert
a8%x = real(a4%x, R8P)                       ! from one kind to another: component by component
a8%y = real(a4%y, R8P)
a8%z = real(a4%z, R8P)
print '(A,ES24.16)', 'x of a8          ', a8%x
!endregion convert
endprogram probe
