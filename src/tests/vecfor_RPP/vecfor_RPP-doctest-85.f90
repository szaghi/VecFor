program volatile_doctest
use vecfor_RPP
 type(vector) :: pt(0:1)
 pt(1) = 1 * ex + 2 * ey + 1 * ez
 pt(0) = 2._R16P - pt(1)
 print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
endprogram volatile_doctest