program volatile_doctest
use vecfor_R8P
 type(vector_R8P) :: pt(0:1)
 pt(1) = 1 * ex_R8P + 2 * ey_R8P + 1 * ez_R8P
 pt(0) = 2_I8P - pt(1)
 print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
endprogram volatile_doctest