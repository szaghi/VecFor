program volatile_doctest
use vecfor_R16P
 type(vector_R16P) :: pt
 pt = 1 * ex_R16P + 2 * ey_R16P + 3 * ez_R16P
 print "(3(F3.1,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
endprogram volatile_doctest