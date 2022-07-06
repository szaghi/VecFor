program volatile_doctest
use vecfor_R16P
 type(vector_R16P) :: pt(0:1)
 pt(1) = 1 * ex_R16P + 2 * ey_R16P + 1 * ez_R16P
 pt(0) = pt(1) + 2_I4P
 print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
endprogram volatile_doctest