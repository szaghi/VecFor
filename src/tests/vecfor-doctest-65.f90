program volatile_doctest
use vecfor
 type(vector) :: pt(0:1)
 pt(1) = 1 * ex + 2 * ey + 1 * ez
 pt(0) = pt(1) / 2_I1P
 print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
endprogram volatile_doctest