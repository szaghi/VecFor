!$acc parallel loop copyin(g, p) copyout(d) private(s12, s13, nrm, r, t)
do i = 1, n
   call vector_sub_vector_oac(p(3), p(2), s12)
   call vector_sub_vector_oac(p(4), p(2), s13)
   call crossproduct_oac(s12, s13, nrm)
   call vector_mul_R8P_oac(nrm, 1._R8P / sqrt(dotproduct_oac(nrm, nrm)), t)   ! the unit normal
   call assign_vector_oac(nrm, t)
   call R8P_mul_vector_oac(-1._R8P, p(2), t)
   call vector_sum_vector_oac(g(i), t, r)                                      ! r = g(i) - p(2)
   d(i) = dotproduct_oac(nrm, r)
enddo
