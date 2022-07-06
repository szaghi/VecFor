program volatile_doctest
use vecfor_R4P
 type(vector_R4P) :: pt(0:2)
 pt(1) = 2 * ex_R4P + 3 * ey_R4P
 pt(2) = ex_R4P
 pt(0) = pt(1).paral.pt(2)
 print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
endprogram volatile_doctest