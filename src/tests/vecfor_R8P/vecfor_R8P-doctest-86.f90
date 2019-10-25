program volatile_doctest
use vecfor_R8P
 type(vector_R8P) :: pt(0:1)
 pt(1) = 1 * ex_R8P + 2 * ey_R8P + 1 * ez_R8P
 pt(0) = pt(1) - 3._R16P
 print "(3(F4.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
endprogram volatile_doctest