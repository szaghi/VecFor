program volatile_doctest
use vecfor_R4P
 type(vector_R4P) :: pt(0:1)
 pt(1) = 1 * ex_R4P + 2 * ey_R4P + 1 * ez_R4P
 pt(0) = 2._R4P - pt(1)
 print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
endprogram volatile_doctest