program volatile_doctest
use vecfor_R16P
 type(vector) :: pt(0:2)
 pt(1) = 2 * ex + 3 * ey
 pt(2) = ex
 pt(0) = pt(1).ortho.pt(2)
 print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
endprogram volatile_doctest