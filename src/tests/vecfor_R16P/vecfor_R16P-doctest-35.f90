program volatile_doctest
use vecfor_R16P
 type(vector) :: pt
 pt = 1 * ex + 2 * ey + 3 * ez
 print "(3(F3.1,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
endprogram volatile_doctest