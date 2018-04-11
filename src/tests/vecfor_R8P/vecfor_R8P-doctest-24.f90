program volatile_doctest
use vecfor_R8P
 type(vector) :: pt
 pt = ex + ey
 print "(F4.2)", normL2(pt)
endprogram volatile_doctest