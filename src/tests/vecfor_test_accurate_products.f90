!< Accuracy test of `crossproduct_accurate` and `dotproduct_accurate` (Kahan's a*b - c*d and Dot2).
!<
!< Crafted cases with an exactly representable result that the plain operators cannot reach (their products round)
!< check exactness on every compiler, in single and double precision. Where the compiler has a 128-bit real, a scan
!< of nearly parallel vectors compares double precision results with quad references (the products of doubles are
!< exact in quad): the accurate cross product within 2 ulps of each component, Dot2 within one rounding plus the
!< classic second-order term.
program vecfor_test_accurate_products
use penf, only : R4P, R8P, R16P
use vecfor, only : crossproduct_accurate_R4P, crossproduct_accurate_R8P, dotproduct_accurate_R4P, &
                   dotproduct_accurate_R8P, vector_R4P, vector_R8P, vector_R16P
implicit none
integer,   parameter :: QUAD = selected_real_kind(33, 4931) !< Compiler's 128-bit kind, negative if none.
integer,   parameter :: n = 2000                           !< Pairs in the quad scan.
real(R8P)            :: k8                                 !< 2**27: (k8 + 1)**2 needs 55 bits.
real(R4P)            :: k4                                 !< 2**12: (k4 + 1)**2 needs 25 bits.
type(vector_R8P)     :: a8, b8, c8                         !< Double precision vectors.
type(vector_R4P)     :: a4, b4, c4                         !< Single precision vectors.
type(vector_R16P)    :: a16, b16, c16                      !< References (quad where the compiler has it).
real(R8P)            :: d8, err, bnd, worst_c, worst_d, naive_worst
real(R16P)           :: d16, s16
integer              :: i, j
logical              :: passed

passed = .true.
k8 = 2._R8P**27
k4 = 2._R4P**12
! crafted cases: exact results 2k + 1 (cross, z) and 2k + 2 (dot)
a8 = vector_R8P(x=k8 + 1, y=k8, z=1._R8P)
b8 = vector_R8P(x=k8, y=k8 + 1, z=0._R8P)
c8 = crossproduct_accurate_R8P(a8, b8)
if (c8%z /= 2 * k8 + 1) then
   print "(A,ES24.16)", "R8P accurate cross z wrong: ", c8%z
   passed = .false.
endif
b8 = vector_R8P(x=k8 + 1, y=-k8, z=1._R8P)
if (dotproduct_accurate_R8P(a8, b8) /= 2 * k8 + 2) then
   print "(A,ES24.16)", "R8P accurate dot wrong: ", dotproduct_accurate_R8P(a8, b8)
   passed = .false.
endif
print "(A,ES24.16,A)", "R8P plain dot of the crafted case: ", a8%dotproduct(b8), " (exact: 268435458)"
a4 = vector_R4P(x=k4 + 1, y=k4, z=1._R4P)
b4 = vector_R4P(x=k4, y=k4 + 1, z=0._R4P)
c4 = crossproduct_accurate_R4P(a4, b4)
b4 = vector_R4P(x=k4 + 1, y=-k4, z=1._R4P)
if (c4%z /= 2 * k4 + 1 .or. dotproduct_accurate_R4P(a4, b4) /= 2 * k4 + 2) then
   print "(A)", "R4P accurate cross/dot wrong on the crafted cases"
   passed = .false.
endif
! quad scan: nearly parallel pairs, b = a + small perturbation
if (QUAD > 0 .and. R16P == QUAD) then
   worst_c = 0 ; worst_d = 0 ; naive_worst = 0
   do i = 1, n
      a8 = vector_R8P(x=1._R8P + sin(real(i, R8P)), y=2._R8P + cos(3._R8P * i), z=0.5_R8P * sin(7._R8P * i))
      b8 = vector_R8P(x=a8%x * (1 + 1e-9_R8P * sin(11._R8P * i)), y=a8%y * (1 + 1e-9_R8P * cos(13._R8P * i)), &
                      z=a8%z + 1e-12_R8P * sin(17._R8P * i))
      a16 = vector_R16P(x=real(a8%x, R16P), y=real(a8%y, R16P), z=real(a8%z, R16P))
      b16 = vector_R16P(x=real(b8%x, R16P), y=real(b8%y, R16P), z=real(b8%z, R16P))
      c16 = a16%crossproduct(b16)
      c8 = crossproduct_accurate_R8P(a8, b8)
      do j = 1, 3
         select case (j)
         case (1) ; err = abs(real(real(c8%x, R16P) - c16%x, R8P)) ; bnd = abs(real(c16%x, R8P))
         case (2) ; err = abs(real(real(c8%y, R16P) - c16%y, R8P)) ; bnd = abs(real(c16%y, R8P))
         case (3) ; err = abs(real(real(c8%z, R16P) - c16%z, R8P)) ; bnd = abs(real(c16%z, R8P))
         endselect
         if (bnd > 0) worst_c = max(worst_c, err / (epsilon(1._R8P) * bnd))
         if (err > epsilon(1._R8P) * bnd + tiny(1._R8P)) passed = .false.
      enddo
      c8 = a8%crossproduct(b8)
      if (abs(real(c16%z, R8P)) > 0) naive_worst = max(naive_worst, abs(real(real(c8%z, R16P) - c16%z, R8P)) / &
                                                       (epsilon(1._R8P) * abs(real(c16%z, R8P))))
      d16 = a16%dotproduct(b16)
      s16 = abs(a16%x * b16%x) + abs(a16%y * b16%y) + abs(a16%z * b16%z)
      d8 = dotproduct_accurate_R8P(a8, b8)
      err = abs(real(real(d8, R16P) - d16, R8P))
      bnd = 0.5_R8P * epsilon(1._R8P) * abs(real(d16, R8P)) + 100 * epsilon(1._R8P)**2 * real(s16, R8P)
      worst_d = max(worst_d, err / max(bnd, tiny(1._R8P)))
      if (err > bnd) passed = .false.
   enddo
   print "(A,F6.3,A,F6.3,A,ES10.3)", "quad scan: accurate cross worst error / (eps*|c|) = ", worst_c, &
         ", accurate dot worst error / bound = ", worst_d, ", plain cross z worst error / (eps*|c|) = ", naive_worst
else
   print "(A)", "no 128-bit real: quad scan skipped (crafted cases checked)"
endif
print "(A,L1)", "Are all tests passed? ", passed
if (.not. passed) error stop 1
endprogram vecfor_test_accurate_products
