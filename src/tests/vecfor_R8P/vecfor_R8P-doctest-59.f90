program volatile_doctest
use vecfor_R8P
 type(vector_R8P) :: pt(0:2)
 pt(1) = 1 * ex_R8P + 1 * ey_R8P + 1 * ez_R8P
 pt(2) = pt(1) + 1
 pt(0) = pt(1) / pt(2)
 print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
endprogram volatile_doctest