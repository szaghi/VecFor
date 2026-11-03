!< Quadruple-precision regression test for `vector_R16P`.
!<
!< When the compiler offers a 128-bit real kind, the build must enable it (`-DPENF_R16P`): PENF's `R16P` must be
!< genuine quad and `vector_R16P` arithmetic must resolve below the double-precision epsilon. Without the macro PENF
!< silently aliases `R16P` to double precision; v1.5.0 to v1.5.2 shipped that way because the build passed a dead
!< macro, and no test noticed. The expectation is taken from the compiler, not from the macro, so a dead macro fails
!< here. A compiler without real(16) (e.g. nvfortran on x86-64) must get the documented double fallback.
program vecfor_test_quad_precision
use penf, only : R8P, R16P
use vecfor, only : ex_R16P, vector_R16P
implicit none
integer, parameter :: QUAD = selected_real_kind(33, 4931) !< Compiler's 128-bit kind, negative if none.
type(vector_R16P)  :: a                                   !< Vector with a component just above 1.
type(vector_R16P)  :: c                                   !< Difference that only survives in quad precision.
real(R16P)         :: tiny_q                              !< Offset below the double epsilon, above the quad one.
logical            :: passed                              !< Test result.

tiny_q = 2._R16P**(-100)
a = (1._R16P + tiny_q) * ex_R16P
c = a - ex_R16P
if (QUAD > 0) then
  passed = R16P == QUAD .and. storage_size(a%x) == 128 .and. c%x == tiny_q
else
  passed = R16P == R8P .and. c%x == 0._R16P
endif
print '(A,I0,A,I0,A,I0)', 'compiler quad kind: ', QUAD, ', R16P precision: ', precision(a%x), &
                          ', storage bits: ', storage_size(a%x)
print '(A,L1)', 'Are all tests passed? ', passed
if (.not. passed) error stop 1
endprogram vecfor_test_quad_precision
