program volatile_doctest
use vecfor_RPP
 type(vector) :: pt
 pt = ex + ey + ez
 print "(L1)", 4_I8P >= pt
endprogram volatile_doctest