program volatile_doctest
use vecfor_R8P
 type(vector_R8P) :: pt(0:1)
 character(4) :: res(3)
 pt(1) = 1 * ex_R8P + 2 * ey_R8P + 1 * ez_R8P
 pt(0) = pt(1) - 2._R8P
 res(1) = trim(adjustl(str('(F4.1)',pt(0)%x)))
 res(2) = trim(adjustl(str('(F4.1)',pt(0)%y)))
 res(3) = trim(adjustl(str('(F4.1)',pt(0)%z)))
 print "(A4,1X,A3,1X,A4)", res(1), res(2), res(3)
endprogram volatile_doctest