program volatile_doctest
use vecfor_RPP
 type(vector) :: pt
 pt = ex + ey
 pt = pt%normalized()
 print "(3(F4.2,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
endprogram volatile_doctest