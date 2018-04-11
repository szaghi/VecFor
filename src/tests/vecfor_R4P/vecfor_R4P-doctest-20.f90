program volatile_doctest
use vecfor_R4P
 type(vector) :: pt
 pt = ex + ey
 call pt%normalize
 print "(3(F4.2,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
endprogram volatile_doctest