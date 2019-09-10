program volatile_doctest
use vecfor_R4P
 type(vector_R4P) :: pt(0:2)
 pt(1) = 1 * ex_R4P + 1 * ey_R4P + 1 * ez_R4P
 pt(2) = pt(1) + 1
 pt(0) = pt(1) - pt(2)
 print "(3(F4.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
endprogram volatile_doctest