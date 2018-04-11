program volatile_doctest
use vecfor_R4P
 type(vector) :: pt(0:2)
 pt(1) = 1 * ex + 1 * ey + 1 * ez
 pt(2) = pt(1) + 1
 pt(0) = pt(1) - pt(2)
 print "(3(F4.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
endprogram volatile_doctest