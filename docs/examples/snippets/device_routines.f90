program device_routines
!< Cookbook: the seven device-callable routines, inside an OpenACC loop; the same results as the operators.
use penf, only : R8P
use vecfor, only : assign_vector_oac, crossproduct_oac, dotproduct_oac, ex, ey, ez, R8P_mul_vector_oac, vector, &
                   vector_mul_R8P_oac, vector_sub_vector_oac, vector_sum_vector_oac
implicit none
integer, parameter :: n = 1000
type(vector)       :: a(n), b(n), c(n), d(n), e(n), f(n), g(n), h(n)
real(R8P)          :: dots(n)
integer            :: i

do i = 1, n
   a(i) = i * ex + ey / i
   b(i) = ez - i * ey
enddo
!$acc parallel loop copyin(a, b) copyout(c, d, e, f, g, h, dots)
do i = 1, n
   call vector_sum_vector_oac(a(i), b(i), c(i))       ! c = a + b
   call vector_sub_vector_oac(a(i), b(i), d(i))       ! d = a - b
   call crossproduct_oac(a(i), b(i), e(i))            ! e = a .cross. b
   call R8P_mul_vector_oac(2._R8P, a(i), f(i))        ! f = 2 * a
   call vector_mul_R8P_oac(a(i), 0.5_R8P, g(i))       ! g = a * 0.5
   call assign_vector_oac(h(i), b(i))                 ! h = b
   dots(i) = dotproduct_oac(a(i), b(i))               ! a .dot. b
enddo
print '(A,L1)', 'a + b       ', all(c == a + b)
print '(A,L1)', 'a - b       ', all(d == a - b)
print '(A,L1)', 'a .cross. b ', all(e == (a .cross. b))
print '(A,L1)', '2 * a       ', all(f == 2._R8P * a)
print '(A,L1)', 'a * 0.5     ', all(g == a * 0.5_R8P)
print '(A,L1)', 'h = b       ', all(h == b)
print '(A,L1)', 'a .dot. b   ', all(dots == (a .dot. b))
endprogram device_routines
