!$acc parallel loop copyin(g, p) copyout(d) private(s12, s13, nrm, r, t)
do i = 1, n
   call vector_sub_vector_dev(p(3), p(2), s12)
   call vector_sub_vector_dev(p(4), p(2), s13)
   call crossproduct_dev(s12, s13, nrm)
   call vector_mul_R8P_dev(nrm, 1._R8P / sqrt(dotproduct_dev(nrm, nrm)), t)   ! the unit normal
   call assign_vector_dev(nrm, t)
   call R8P_mul_vector_dev(-1._R8P, p(2), t)
   call vector_sum_vector_dev(g(i), t, r)                                      ! r = g(i) - p(2)
   d(i) = dotproduct_dev(nrm, r)
enddo
