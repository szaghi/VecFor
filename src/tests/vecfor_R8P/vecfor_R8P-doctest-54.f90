program volatile_doctest
use vecfor_R8P
 type(vector) :: pt(0:1)
 pt(1) = 1 * ex + 2 * ey + 1 * ez
 pt(0) = 2_I2P * pt(1)
 print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
endprogram volatile_doctest