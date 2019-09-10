program volatile_doctest
use vecfor_R8P
 type(vector_R8P) :: pt
 pt = 1 * ex_R8P + 2 * ey_R8P + 3 * ez_R8P
 print "(3(F3.1,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
endprogram volatile_doctest