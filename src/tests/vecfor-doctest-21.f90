program volatile_doctest
use vecfor
 type(vector) :: pt
 pt = ex + ey
 print "(F4.2)", pt%normL2()
endprogram volatile_doctest